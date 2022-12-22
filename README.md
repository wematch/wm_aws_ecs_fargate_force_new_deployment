# ECS Fargate - Force New Deployment
Force New Deployment for ECS Fargate services

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | n/a | `any` | n/a | yes |
| <a name="input_cloudwatch_logs_retention_in_days"></a> [cloudwatch\_logs\_retention\_in\_days](#input\_cloudwatch\_logs\_retention\_in\_days) | n/a | `number` | `3` | no |
| <a name="input_ecs_cluster"></a> [ecs\_cluster](#input\_ecs\_cluster) | n/a | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | Schedule rule for Lambda | `map` | <pre>{<br>  "description": "Fires Lambda every Sunday morning at 7 UTC",<br>  "expression": "cron(0 7 ? * SUN *)",<br>  "name": "run-every-week"<br>}</pre> | no |
| <a name="input_standard_tags"></a> [standard\_tags](#input\_standard\_tags) | n/a | `map(string)` | n/a | yes |

## Outputs

No outputs.
