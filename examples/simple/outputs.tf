output "id" {
  value       = module.this.id
  description = "The normalized ID from the 'bendoerr-terraform-modules/terraform-null-label' module."
}

output "tags" {
  value       = module.this.tags
  description = "The normalized tags from the 'bendoerr-terraform-modules/terraform-null-label' module."
}

output "name" {
  value       = module.this.name
  description = "The provided name given to the module."
}

output "lambda_function_arn" {
  value       = module.this.lambda_function_arn
  description = "ARN of the deployed Lambda function"
}
