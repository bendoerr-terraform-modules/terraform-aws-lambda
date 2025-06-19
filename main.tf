module "label" {
  source  = "bendoerr-terraform-modules/label/null"
  version = "0.5.0"
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
  kms_key_arn = var.env_kms_key_arn

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "tracing_config" {
    for_each = var.enable_tracing ? [true] : []
    content {
      mode = var.tracing_mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.vpc_security_group_ids
      subnet_ids         = var.vpc_subnet_ids
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.enable_cloudwatch_logs ? 1 : 0
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = var.cloudwatch_retention_in_days
  kms_key_id        = var.cloudwatch_kms_key_arn
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
  count = var.enable_cloudwatch_logs ? 1 : 0
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
  count  = var.enable_cloudwatch_logs ? 1 : 0
  role   = aws_iam_role.this.name
  name   = "cloudwatch-logs"
  policy = data.aws_iam_policy_document.cloudwatch_logs[0].json
}

resource "aws_iam_role_policy_attachment" "aws_xray_write_only_access" {
  count      = var.enable_tracing ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "vpc_attachment" {
  count      = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? 1 : 0
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
