<br/>
<p align="center">
  <a href="https://github.com/bendoerr-terraform-modules/terraform-aws-lambda">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/raw/main/docs/logo-dark.png">
      <img src="https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/raw/main/docs/logo-light.png" alt="Logo">
    </picture>
  </a>

<h3 align="center">Ben's Terraform AWS Lambda Module</h3>

<p align="center">
    This is how I do it.
    <br/>
    <br/>
    <a href="https://github.com/bendoerr-terraform-modules/terraform-aws-lambda"><strong>Explore the docs »</strong></a>
    <br/>
    <br/>
    <a href="https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/issues">Report Bug</a>
    .
    <a href="https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/issues">Request Feature</a>
  </p>
</p>

[<img alt="GitHub contributors" src="https://img.shields.io/github/contributors/bendoerr-terraform-modules/terraform-aws-lambda?logo=github">](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/graphs/contributors)
[<img alt="GitHub issues" src="https://img.shields.io/github/issues/bendoerr-terraform-modules/terraform-aws-lambda?logo=github">](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/issues)
[<img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/bendoerr-terraform-modules/terraform-aws-lambda?logo=github">](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/pulls)
[<img alt="GitHub workflow: Terratest" src="https://img.shields.io/github/actions/workflow/status/bendoerr-terraform-modules/terraform-aws-lambda/test.yml?logo=githubactions&label=terratest">](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/actions/workflows/test.yml)
[<img alt="GitHub workflow: Linting" src="https://img.shields.io/github/actions/workflow/status/bendoerr-terraform-modules/terraform-aws-lambda/lint.yml?logo=githubactions&label=linting">](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/actions/workflows/lint.yml)
[<img alt="GitHub tag (with filter)" src="https://img.shields.io/github/v/tag/bendoerr-terraform-modules/terraform-aws-lambda?filter=v*&label=latest%20tag&logo=terraform">](https://registry.terraform.io/modules/bendoerr-terraform-modules/terraform-aws-lambda/aws/latest)
[<img alt="OSSF-Scorecard Score" src="https://img.shields.io/ossf-scorecard/github.com/bendoerr-terraform-modules/terraform-aws-lambda?logo=securityscorecard&label=ossf%20scorecard&link=https%3A%2F%2Fsecurityscorecards.dev%2Fviewer%2F%3Furi%3Dgithub.com%2Fbendoerr-terraform-modules%2Fterraform-aws-lambda">](https://securityscorecards.dev/viewer/?uri=github.com/bendoerr-terraform-modules/terraform-aws-lambda)
[<img alt="GitHub License" src="https://img.shields.io/github/license/bendoerr-terraform-modules/terraform-aws-lambda?logo=opensourceinitiative">](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/blob/main/LICENSE.txt)

## About The Project

TODO

## Usage

TODO

## Version Constraints

This module uses **pessimistic version constraints** (`~>`) for its providers to
ensure predictable behavior across deployments:

```hcl
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 6.0" # Allows 6.x, prevents 7.0
  }
}
```

**Why pessimistic constraints?**

- Prevents unexpected breaking changes from major provider updates
- Ensures consistent behavior across environments
- Makes upgrade impact predictable and controllable

When AWS provider v7.0 releases, this module will require an update to support it.
That is intentional — we prefer explicit, tested upgrades over automatic major
version bumps.

For consuming this module, you can use any AWS provider version that satisfies both
your requirements and this module's constraints. Terraform's dependency resolver
will find a compatible version automatically.

<!-- BEGIN_TF_DOCS -->

### Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | ~> 6.0 |

### Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | ~> 6.0 |

### Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_label"></a> [label](#module_label) | bendoerr-terraform-modules/label/null | 1.0.0 |

### Resources

| Name | Type |
| ---- | ---- |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.addl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.addl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aws_xray_write_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vpc_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_addl_assume_role_policy_principles"></a> [addl_assume_role_policy_principles](#input_addl_assume_role_policy_principles) | Additional assume role policy principles for the lambda IAM role, such as 'edgelambda.amazonaws.com'. | `list(string)` | `[]` | no |
| <a name="input_addl_inline_policies"></a> [addl_inline_policies](#input_addl_inline_policies) | A map of additional inline policies to attach to the IAM role. The key is the policy name, and the value is a JSON policy document. | `map(string)` | `{}` | no |
| <a name="input_addl_policies"></a> [addl_policies](#input_addl_policies) | A list of additional policy ARNs to attach to the Lambda's IAM role | `list(string)` | `[]` | no |
| <a name="input_architectures"></a> [architectures](#input_architectures) | Architectures supported by the Lambda function (e.g., x86_64, arm64) | `list(string)` | <pre>\[<br/>  "x86_64"<br/>\]</pre> | no |
| <a name="input_cloudwatch_kms_key_arn"></a> [cloudwatch_kms_key_arn](#input_cloudwatch_kms_key_arn) | DEPRECATED, use cloudwatch_logs.kms_key_arn instead. KMS Key ARN to encrypt the CloudWatch Logs. | `string` | `null` | no |
| <a name="input_cloudwatch_logs"></a> [cloudwatch_logs](#input_cloudwatch_logs) | CloudWatch Logs configuration for the Lambda function. Takes precedence over the deprecated enable_cloudwatch_logs / cloudwatch_retention_in_days / cloudwatch_kms_key_arn variables. | <pre>object({<br/>    enabled           = optional(bool, true)<br/>    retention_in_days = optional(number, 30)<br/>    kms_key_arn       = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_cloudwatch_retention_in_days"></a> [cloudwatch_retention_in_days](#input_cloudwatch_retention_in_days) | DEPRECATED, use cloudwatch_logs.retention_in_days instead. Number of days to retain log events in the specified log group. | `number` | `30` | no |
| <a name="input_context"></a> [context](#input_context) | Shared context from the 'bendoerr-terraform-modules/terraform-null-context' module. | <pre>object({<br/>    attributes     = list(string)<br/>    dns_namespace  = string<br/>    environment    = string<br/>    instance       = string<br/>    instance_short = string<br/>    namespace      = string<br/>    region         = string<br/>    region_short   = string<br/>    role           = string<br/>    role_short     = string<br/>    project        = string<br/>    tags           = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_description"></a> [description](#input_description) | Description of the Lambda function | `string` | n/a | yes |
| <a name="input_enable_cloudwatch_logs"></a> [enable_cloudwatch_logs](#input_enable_cloudwatch_logs) | DEPRECATED, use cloudwatch_logs.enabled instead. Flag to enable or disable the creation of CloudWatch Logs. | `bool` | `true` | no |
| <a name="input_enable_tracing"></a> [enable_tracing](#input_enable_tracing) | DEPRECATED, use tracing_config.enabled instead. Whether to enable AWS X-Ray tracing for the Lambda function. | `bool` | `false` | no |
| <a name="input_env_kms_key_arn"></a> [env_kms_key_arn](#input_env_kms_key_arn) | DEPRECATED, use environment.kms_key_arn instead. The ARN of the KMS key to be used for encrypting environment variables in the Lambda function. | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input_environment) | Environment variable configuration for the Lambda function. Takes precedence over the deprecated environment_variables / env_kms_key_arn variables. | <pre>object({<br/>    variables   = optional(map(string), {})<br/>    kms_key_arn = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_environment_variables"></a> [environment_variables](#input_environment_variables) | DEPRECATED, use environment.variables instead. Key-value pairs of environment variables for the Lambda function. | `map(string)` | `{}` | no |
| <a name="input_filename"></a> [filename](#input_filename) | Path to the file with the AWS Lambda function source code. | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input_handler) | The function entrypoint in your code. | `string` | n/a | yes |
| <a name="input_layers"></a> [layers](#input_layers) | List of ARNs of Lambda layers to include | `list(string)` | `[]` | no |
| <a name="input_memory_size"></a> [memory_size](#input_memory_size) | Amount of memory in MB allocated for the Lambda function | `number` | `128` | no |
| <a name="input_name"></a> [name](#input_name) | A descriptive but short name used for labels by the 'bendoerr-terraform-modules/terraform-null-label' module. | `string` | `"thing"` | no |
| <a name="input_publish"></a> [publish](#input_publish) | Whether to publish a new version of the Lambda function | `bool` | `false` | no |
| <a name="input_runtime"></a> [runtime](#input_runtime) | Runtime environment for the Lambda function (e.g., python3.9, nodejs14.x) | `string` | n/a | yes |
| <a name="input_source_code_hash"></a> [source_code_hash](#input_source_code_hash) | Used to trigger updates when the content of the Lambda function changes (filebase64sha256 of the source code). If not provided, filebase64sha256(var.filename) will be used. | `string` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input_timeout) | Timeout in seconds before the Lambda function is terminated | `number` | `3` | no |
| <a name="input_tracing_config"></a> [tracing_config](#input_tracing_config) | X-Ray tracing configuration for the Lambda function. Takes precedence over the deprecated enable_tracing / tracing_mode variables. | <pre>object({<br/>    enabled = optional(bool, false)<br/>    mode    = optional(string, "PassThrough")<br/>  })</pre> | `null` | no |
| <a name="input_tracing_mode"></a> [tracing_mode](#input_tracing_mode) | DEPRECATED, use tracing_config.mode instead. Tracing mode for AWS X-Ray (e.g., PassThrough, Active). | `string` | `"PassThrough"` | no |
| <a name="input_vpc_config"></a> [vpc_config](#input_vpc_config) | VPC configuration for the Lambda function. When set, takes precedence over the deprecated vpc_subnet_ids / vpc_security_group_ids variables; when null, those are used as a fallback. If neither the object nor the legacy variables are set, the function is not deployed in a VPC. | <pre>object({<br/>    subnet_ids         = list(string)<br/>    security_group_ids = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc_security_group_ids](#input_vpc_security_group_ids) | DEPRECATED, use vpc_config.security_group_ids instead. List of security group IDs for the Lambda function VPC configuration. | `list(string)` | `null` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc_subnet_ids](#input_vpc_subnet_ids) | DEPRECATED, use vpc_config.subnet_ids instead. List of subnet IDs for the Lambda function VPC configuration. | `list(string)` | `null` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch_log_group_arn](#output_cloudwatch_log_group_arn) | The ARN of the CloudWatch Log Group for the Lambda function |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch_log_group_name](#output_cloudwatch_log_group_name) | The name of the CloudWatch Log Group for the Lambda function |
| <a name="output_iam_role_arn"></a> [iam_role_arn](#output_iam_role_arn) | ARN of the IAM role attached to the Lambda function |
| <a name="output_id"></a> [id](#output_id) | The normalized ID from the 'bendoerr-terraform-modules/terraform-null-label' module. |
| <a name="output_lambda_function_arn"></a> [lambda_function_arn](#output_lambda_function_arn) | ARN of the deployed Lambda function |
| <a name="output_lambda_function_invoke_arn"></a> [lambda_function_invoke_arn](#output_lambda_function_invoke_arn) | The invoke ARN of the Lambda function |
| <a name="output_lambda_function_name"></a> [lambda_function_name](#output_lambda_function_name) | Name of the deployed Lambda function |
| <a name="output_lambda_function_version"></a> [lambda_function_version](#output_lambda_function_version) | The published version of the Lambda function |
| <a name="output_lambda_layers_arns"></a> [lambda_layers_arns](#output_lambda_layers_arns) | The ARNs of the Lambda layers attached to the function |
| <a name="output_name"></a> [name](#output_name) | The provided name given to the module. |
| <a name="output_tags"></a> [tags](#output_tags) | The normalized tags from the 'bendoerr-terraform-modules/terraform-null-label' module. |

<!-- END_TF_DOCS -->

## Roadmap

[<img alt="GitHub issues" src="https://img.shields.io/github/issues/bendoerr-terraform-modules/terraform-aws-lambda?logo=github">](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/issues)

See the [open issues](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/issues) for a list of
proposed features (and known issues).

## Contributing

[<img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/bendoerr-terraform-modules/terraform-aws-lambda?logo=github">](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/pulls)

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any
contributions you make are **greatly appreciated**.

- If you have suggestions for adding or removing projects, feel free to
  [open an issue](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/issues/new) to discuss it,
  or directly create a pull request after you edit the _README.md_ file with necessary changes.
- Please make sure you check your spelling and grammar.
- Create individual PR for each suggestion.

### Creating A Pull Request

1. Fork the Project
1. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
1. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
1. Push to the Branch (`git push origin feature/AmazingFeature`)
1. Open a Pull Request

## License

[<img alt="GitHub License" src="https://img.shields.io/github/license/bendoerr-terraform-modules/terraform-aws-lambda?logo=opensourceinitiative">](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/blob/main/LICENSE.txt)

Distributed under the MIT License. See
[LICENSE](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/blob/main/LICENSE.txt) for more
information.

## Authors

[<img alt="GitHub contributors" src="https://img.shields.io/github/contributors/bendoerr-terraform-modules/terraform-aws-lambda?logo=github">](https://github.com/bendoerr-terraform-modules/terraform-aws-lambda/graphs/contributors)

- **Benjamin R. Doerr** - _Terraformer_ - [Benjamin R. Doerr](https://github.com/bendoerr/) - _Built Ben's Terraform Modules_

## Supported Versions

Only the latest tagged version is supported.

## Reporting a Vulnerability

See [SECURITY.md](SECURITY.md).

## Acknowledgements

- [ShaanCoding (ReadME Generator)](https://github.com/ShaanCoding/ReadME-Generator)
- [OpenSSF - Helping me follow best practices](https://openssf.org/)
- [StepSecurity - Helping me follow best practices](https://app.stepsecurity.io/)
- [Infracost - Better than AWS Calculator](https://www.infracost.io/)
