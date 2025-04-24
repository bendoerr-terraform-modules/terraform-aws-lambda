output "id" {
  value       = module.label.id
  description = "The normalized ID from the 'bendoerr-terraform-modules/terraform-null-label' module."
}

output "tags" {
  value       = module.label.tags
  description = "The normalized tags from the 'bendoerr-terraform-modules/terraform-null-label' module."
}

output "name" {
  value       = var.name
  description = "The provided name given to the module."
}

output "lambda_function_arn" {
  description = "ARN of the deployed Lambda function"
  value       = aws_lambda_function.this.arn
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "lambda_function_version" {
  description = "The published version of the Lambda function"
  value       = aws_lambda_function.this.version
}

output "lambda_function_invoke_arn" {
  description = "The invoke ARN of the Lambda function"
  value       = aws_lambda_function.this.invoke_arn
}

output "lambda_layers_arns" {
  description = "The ARNs of the Lambda layers attached to the function"
  value       = aws_lambda_function.this.layers
}

output "iam_role_arn" {
  description = "ARN of the IAM role attached to the Lambda function"
  value       = aws_iam_role.this.arn
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Log Group for the Lambda function"
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.this[0].name : null
}

output "cloudwatch_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for the Lambda function"
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.this[0].arn : null
}
