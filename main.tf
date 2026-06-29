locals {
  # Config-group bridge (issue #30). The grouped object variables are the
  # preferred API; when one is set (non-null) it wins, otherwise the module
  # falls back to the deprecated flat variables so existing callers keep working
  # unchanged. Drop the flat variables and this bridge in a future major release.

  # VPC
  vpc_subnet_ids         = var.vpc_config != null ? var.vpc_config.subnet_ids : var.vpc_subnet_ids
  vpc_security_group_ids = var.vpc_config != null ? var.vpc_config.security_group_ids : var.vpc_security_group_ids
  vpc_enabled            = local.vpc_subnet_ids != null && local.vpc_security_group_ids != null

  # X-Ray tracing
  tracing_enabled = var.tracing_config != null ? var.tracing_config.enabled : var.enable_tracing
  tracing_mode    = var.tracing_config != null ? var.tracing_config.mode : var.tracing_mode

  # CloudWatch Logs
  cloudwatch_enabled           = var.cloudwatch_logs != null ? var.cloudwatch_logs.enabled : var.enable_cloudwatch_logs
  cloudwatch_retention_in_days = var.cloudwatch_logs != null ? var.cloudwatch_logs.retention_in_days : var.cloudwatch_retention_in_days
  cloudwatch_kms_key_arn       = var.cloudwatch_logs != null ? var.cloudwatch_logs.kms_key_arn : var.cloudwatch_kms_key_arn

  # Environment
  environment_variables = var.environment != null ? var.environment.variables : var.environment_variables
  env_kms_key_arn       = var.environment != null ? var.environment.kms_key_arn : var.env_kms_key_arn
}

module "label" {
  source  = "bendoerr-terraform-modules/label/null"
  version = "1.0.0"
  context = var.context
  name    = var.name
}

resource "aws_lambda_function" "this" {
  function_name = module.label.id
  description   = var.description
  tags          = module.label.tags

  filename         = var.filename
  source_code_hash = var.source_code_hash != null ? var.source_code_hash : filebase64sha256(var.filename)

  runtime       = var.runtime
  memory_size   = var.memory_size
  architectures = var.architectures

  role        = aws_iam_role.this.arn
  handler     = var.handler
  timeout     = var.timeout
  publish     = var.publish
  layers      = var.layers
  kms_key_arn = local.env_kms_key_arn

  dynamic "environment" {
    for_each = length(keys(local.environment_variables)) == 0 ? [] : [true]
    content {
      variables = local.environment_variables
    }
  }

  dynamic "tracing_config" {
    for_each = local.tracing_enabled ? [true] : []
    content {
      mode = local.tracing_mode
    }
  }

  dynamic "vpc_config" {
    for_each = local.vpc_enabled ? [true] : []
    content {
      security_group_ids = local.vpc_security_group_ids
      subnet_ids         = local.vpc_subnet_ids
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  count             = local.cloudwatch_enabled ? 1 : 0
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = local.cloudwatch_retention_in_days
  kms_key_id        = local.cloudwatch_kms_key_arn
  tags              = module.label.tags
}

locals {
  assume_role_policy_principles = flatten([["lambda.amazonaws.com"], var.addl_assume_role_policy_principles])
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = local.assume_role_policy_principles
    }
  }
}

resource "aws_iam_role" "this" {
  name               = module.label.id
  tags               = module.label.tags
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "cloudwatch_logs" {
  count = local.cloudwatch_enabled ? 1 : 0
  statement {
    effect    = "Allow"
    resources = [aws_cloudwatch_log_group.this[0].arn]
    actions = [
      "logs:CreateLogGroup",
    ]
  }
  statement {
    effect = "Allow"
    # We cannot know what the name of the stream will be so this wildcard is the minimal permission
    # tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["${aws_cloudwatch_log_group.this[0].arn}:*"]
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_role_policy" "cloudwatch_logs" {
  count  = local.cloudwatch_enabled ? 1 : 0
  role   = aws_iam_role.this.name
  name   = "cloudwatch-logs"
  policy = data.aws_iam_policy_document.cloudwatch_logs[0].json
}

resource "aws_iam_role_policy_attachment" "aws_xray_write_only_access" {
  count      = local.tracing_enabled ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "vpc_attachment" {
  count      = local.vpc_enabled ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "addl" {
  for_each   = toset(var.addl_policies)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "addl" {
  for_each = var.addl_inline_policies
  name     = each.key
  role     = aws_iam_role.this.name
  policy   = each.value
}
