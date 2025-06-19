terraform {
  # Anything greater than the 1.0.0 release should be sufficient
  required_version = ">= 1.0.0"

  required_providers {
    # Use a v5.x.x version of the AWS provider
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "archive_file" "hello" {
  output_path = "${path.module}/lambda-src/hello.zip"
  type        = "zip"
  source_file = "${path.module}/lambda-src/hello.js"
}

module "this" {
  source  = "../.."
  context = module.context.shared
  name    = "simple"

  description = "A simple example"
  filename    = data.archive_file.hello.output_path
  handler     = "hello.handler"
  runtime     = "nodejs22.x"
}
