variable "context" {
  type = object({
    attributes     = list(string)
    dns_namespace  = string
    environment    = string
    instance       = string
    instance_short = string
    namespace      = string
    region         = string
    region_short   = string
    role           = string
    role_short     = string
    project        = string
    tags           = map(string)
  })
  description = "Shared context from the 'bendoerr-terraform-modules/terraform-null-context' module."
}

variable "name" {
  type        = string
  default     = "thing"
  description = "A descriptive but short name used for labels by the 'bendoerr-terraform-modules/terraform-null-label' module."
  nullable    = false
}

variable "filename" {
  type        = string
  description = "Path to the file with the AWS Lambda function source code."
  nullable    = false
}

variable "handler" {
  type        = string
  description = "The function entrypoint in your code."
  nullable    = false
}

variable "description" {
  description = "Description of the Lambda function"
  type        = string
  nullable    = false
}

variable "runtime" {
  description = "Runtime environment for the Lambda function (e.g., python3.9, nodejs14.x)"
  type        = string
  nullable    = false
}

variable "memory_size" {
  description = "Amount of memory in MB allocated for the Lambda function"
  type        = number
  default     = 128
}

variable "architectures" {
  description = "Architectures supported by the Lambda function (e.g., x86_64, arm64)"
  type        = list(string)
  default     = ["x86_64"]
}

variable "timeout" {
  description = "Timeout in seconds before the Lambda function is terminated"
  type        = number
  default     = 3
}

variable "publish" {
  description = "Whether to publish a new version of the Lambda function"
  type        = bool
  default     = false
}

variable "layers" {
  description = "List of ARNs of Lambda layers to include"
  type        = list(string)
  default     = []
}

variable "env_kms_key_arn" {
  description = "The ARN of the KMS key to be used for encrypting environment variables in the Lambda function"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Key-value pairs of environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "enable_tracing" {
  description = "Whether to enable AWS X-Ray tracing for the Lambda function"
  type        = bool
  default     = false
}

variable "tracing_mode" {
  description = "Tracing mode for AWS X-Ray (e.g., PassThrough, Active)"
  type        = string
  default     = "PassThrough"
}

variable "vpc_subnet_ids" {
  description = "List of subnet IDs for the Lambda function VPC configuration"
  type        = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs for the Lambda function VPC configuration"
  type        = list(string)
  default     = null
}

variable "addl_assume_role_policy_principles" {
  description = "Additional assume role policy principles for the lambda IAM role, such as 'edgelambda.amazonaws.com'."
  type        = list(string)
  default     = []
}

variable "enable_cloudwatch_logs" {
  description = "Flag to enable or disable the creation of CloudWatch Logs"
  type        = bool
  default     = true
}

variable "cloudwatch_retention_in_days" {
  description = "Number of days to retain log events in the specified log group"
  type        = number
  default     = 30
}

variable "cloudwatch_kms_key_arn" {
  description = "KMS Key ARN to encrypt the CloudWatch Logs"
  type        = string
  default     = null
}

variable "addl_policies" {
  description = "A list of additional policy ARNs to attach to the Lambda's IAM role"
  type        = list(string)
  default     = []
}

variable "addl_inline_policies" {
  description = "A map of additional inline policies to attach to the IAM role. The key is the policy name, and the value is a JSON policy document."
  type        = map(string)
  default     = {}
}

variable "source_code_hash" {
  description = "Used to trigger updates when the content of the Lambda function changes (filebase64sha256 of the source code). If not provided, filebase64sha256(var.filename) will be used."
  type        = string
  default     = null
}
