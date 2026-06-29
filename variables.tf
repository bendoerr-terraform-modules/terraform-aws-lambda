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

  validation {
    # Structural (shape) check, NOT a version-locked allow-list: AWS ships new
    # runtimes constantly (python3.14, nodejs24.x, java25, dotnet10, ...), so an
    # enumerated regex would reject valid runtimes the day they launch. This
    # matches the identifier *families* and catches typos (e.g. "node20",
    # "pyhton3.12") while staying forward-compatible.
    condition     = can(regex("^(nodejs\\d+\\.x|python\\d+\\.\\d+|java\\d+(\\.al\\d+)?|dotnet\\d+|dotnetcore\\d+\\.\\d+|ruby\\d+\\.\\d+|go\\d+\\.x|provided(\\.al\\d+)?)$", var.runtime))
    error_message = "runtime must be a valid AWS Lambda runtime identifier (e.g. python3.13, nodejs22.x, java21, dotnet8, ruby3.3, provided.al2023, go1.x)."
  }
}

variable "memory_size" {
  description = "Amount of memory in MB allocated for the Lambda function"
  type        = number
  default     = 128

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240 && floor(var.memory_size) == var.memory_size
    error_message = "memory_size must be a whole number between 128 and 10240 MB."
  }
}

variable "architectures" {
  description = "Architectures supported by the Lambda function (e.g., x86_64, arm64)"
  type        = list(string)
  default     = ["x86_64"]

  validation {
    # AWS Lambda supports exactly one architecture per function.
    condition     = length(var.architectures) == 1 && alltrue([for a in var.architectures : contains(["x86_64", "arm64"], a)])
    error_message = "architectures must be exactly one of [\"x86_64\"] or [\"arm64\"]."
  }
}

variable "timeout" {
  description = "Timeout in seconds before the Lambda function is terminated"
  type        = number
  default     = 3

  validation {
    condition     = var.timeout >= 1 && var.timeout <= 900 && floor(var.timeout) == var.timeout
    error_message = "timeout must be a whole number of seconds between 1 and 900 (15 minutes)."
  }
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

  validation {
    condition     = alltrue([for l in var.layers : can(regex("^arn:aws[a-z-]*:lambda:[a-z0-9-]+:[0-9]{12}:layer:[a-zA-Z0-9-_]+:[0-9]+$", l))])
    error_message = "layers must all be valid Lambda layer version ARNs (e.g. arn:aws:lambda:us-east-1:123456789012:layer:my-layer:1)."
  }
}

variable "environment" {
  description = "Environment variable configuration for the Lambda function. Takes precedence over the deprecated environment_variables / env_kms_key_arn variables."
  type = object({
    variables   = optional(map(string), {})
    kms_key_arn = optional(string)
  })
  default = null

  validation {
    # null kms_key_arn = use the AWS-managed default key (passed straight through).
    # Partition left open (aws / aws-us-gov / aws-cn); key/ allows the mrk- prefix.
    condition     = var.environment == null || var.environment.kms_key_arn == null || can(regex("^arn:aws[a-z-]*:kms:[a-z0-9-]+:[0-9]{12}:(key/[0-9a-zA-Z-]+|alias/[a-zA-Z0-9/_-]+)$", var.environment.kms_key_arn))
    error_message = "environment.kms_key_arn must be null or a valid KMS key or alias ARN (e.g. arn:aws:kms:us-east-1:123456789012:key/<id>)."
  }
}

variable "env_kms_key_arn" {
  description = "DEPRECATED, use environment.kms_key_arn instead. The ARN of the KMS key to be used for encrypting environment variables in the Lambda function."
  type        = string
  default     = null

  validation {
    # null = use the AWS-managed default key (the module passes this value
    # straight through, so only null is the "unset" sentinel). Partition left
    # open (aws / aws-us-gov / aws-cn); key/ allows the mrk- multi-region prefix.
    condition     = var.env_kms_key_arn == null || can(regex("^arn:aws[a-z-]*:kms:[a-z0-9-]+:[0-9]{12}:(key/[0-9a-zA-Z-]+|alias/[a-zA-Z0-9/_-]+)$", var.env_kms_key_arn))
    error_message = "env_kms_key_arn must be null or a valid KMS key or alias ARN (e.g. arn:aws:kms:us-east-1:123456789012:key/<id>)."
  }
}

variable "environment_variables" {
  description = "DEPRECATED, use environment.variables instead. Key-value pairs of environment variables for the Lambda function."
  type        = map(string)
  default     = {}
}

variable "tracing_config" {
  description = "X-Ray tracing configuration for the Lambda function. Takes precedence over the deprecated enable_tracing / tracing_mode variables."
  type = object({
    enabled = optional(bool, false)
    mode    = optional(string, "PassThrough")
  })
  default = null

  validation {
    condition     = var.tracing_config == null || contains(["PassThrough", "Active"], var.tracing_config.mode)
    error_message = "tracing_config.mode must be either \"PassThrough\" or \"Active\"."
  }
}

variable "enable_tracing" {
  description = "DEPRECATED, use tracing_config.enabled instead. Whether to enable AWS X-Ray tracing for the Lambda function."
  type        = bool
  default     = false
}

variable "tracing_mode" {
  description = "DEPRECATED, use tracing_config.mode instead. Tracing mode for AWS X-Ray (e.g., PassThrough, Active)."
  type        = string
  default     = "PassThrough"

  validation {
    condition     = var.tracing_mode == null || contains(["PassThrough", "Active"], var.tracing_mode)
    error_message = "tracing_mode must be either \"PassThrough\" or \"Active\"."
  }
}

variable "vpc_config" {
  description = "VPC configuration for the Lambda function. When set, takes precedence over the deprecated vpc_subnet_ids / vpc_security_group_ids variables; when null, those are used as a fallback. If neither the object nor the legacy variables are set, the function is not deployed in a VPC."
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "vpc_subnet_ids" {
  description = "DEPRECATED, use vpc_config.subnet_ids instead. List of subnet IDs for the Lambda function VPC configuration."
  type        = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "DEPRECATED, use vpc_config.security_group_ids instead. List of security group IDs for the Lambda function VPC configuration."
  type        = list(string)
  default     = null
}

variable "addl_assume_role_policy_principles" {
  description = "Additional assume role policy principles for the lambda IAM role, such as 'edgelambda.amazonaws.com'."
  type        = list(string)
  default     = []
}

variable "cloudwatch_logs" {
  description = "CloudWatch Logs configuration for the Lambda function. Takes precedence over the deprecated enable_cloudwatch_logs / cloudwatch_retention_in_days / cloudwatch_kms_key_arn variables."
  type = object({
    enabled           = optional(bool, true)
    retention_in_days = optional(number, 30)
    kms_key_arn       = optional(string)
  })
  default = null

  validation {
    condition = var.cloudwatch_logs == null || contains(
      [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653],
      var.cloudwatch_logs.retention_in_days
    )
    error_message = "cloudwatch_logs.retention_in_days must be a valid CloudWatch Logs retention value (0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, or 3653). 0 means never expire."
  }

  validation {
    # null kms_key_arn = no CMK (passed straight through). Partition left open
    # (aws / aws-us-gov / aws-cn); key/ allows the mrk- multi-region prefix.
    condition     = var.cloudwatch_logs == null || var.cloudwatch_logs.kms_key_arn == null || can(regex("^arn:aws[a-z-]*:kms:[a-z0-9-]+:[0-9]{12}:(key/[0-9a-zA-Z-]+|alias/[a-zA-Z0-9/_-]+)$", var.cloudwatch_logs.kms_key_arn))
    error_message = "cloudwatch_logs.kms_key_arn must be null or a valid KMS key or alias ARN (e.g. arn:aws:kms:us-east-1:123456789012:key/<id>)."
  }
}

variable "enable_cloudwatch_logs" {
  description = "DEPRECATED, use cloudwatch_logs.enabled instead. Flag to enable or disable the creation of CloudWatch Logs."
  type        = bool
  default     = true
}

variable "cloudwatch_retention_in_days" {
  description = "DEPRECATED, use cloudwatch_logs.retention_in_days instead. Number of days to retain log events in the specified log group."
  type        = number
  default     = 30

  validation {
    condition = contains(
      [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653],
      var.cloudwatch_retention_in_days
    )
    error_message = "cloudwatch_retention_in_days must be a valid CloudWatch Logs retention value (0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, or 3653). 0 means never expire."
  }
}

variable "cloudwatch_kms_key_arn" {
  description = "DEPRECATED, use cloudwatch_logs.kms_key_arn instead. KMS Key ARN to encrypt the CloudWatch Logs."
  type        = string
  default     = null

  validation {
    # null = no CMK (the module passes this straight through). Partition left
    # open (aws / aws-us-gov / aws-cn); key/ allows the mrk- multi-region prefix.
    condition     = var.cloudwatch_kms_key_arn == null || can(regex("^arn:aws[a-z-]*:kms:[a-z0-9-]+:[0-9]{12}:(key/[0-9a-zA-Z-]+|alias/[a-zA-Z0-9/_-]+)$", var.cloudwatch_kms_key_arn))
    error_message = "cloudwatch_kms_key_arn must be null or a valid KMS key or alias ARN (e.g. arn:aws:kms:us-east-1:123456789012:key/<id>)."
  }
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
