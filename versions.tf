terraform {
  # 1.3 is the floor: the grouped configuration variables (vpc_config,
  # tracing_config, cloudwatch_logs, environment) use optional object type
  # attributes, which were introduced in Terraform 1.3.
  required_version = ">= 1.3.0"

  required_providers {
    # Use a v5.x.x version of the AWS provider
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
