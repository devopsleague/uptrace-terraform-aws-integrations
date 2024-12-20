<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.9.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kfh"></a> [kfh](#module\_kfh) | ../kinesis-firehose | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_stream.metric-stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_stream) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_http_buffering_interval"></a> [http\_buffering\_interval](#input\_http\_buffering\_interval) | Kinesis Firehose http buffer interval, in seconds. | `number` | `60` | no |
| <a name="input_http_buffering_size"></a> [http\_buffering\_size](#input\_http\_buffering\_size) | Kinesis Firehose http buffer size, in MiB. | `number` | `15` | no |
| <a name="input_enable_lambda_transform"></a> [enable\_lambda\_transform](#input\_enable\_lambda\_transform) | Enable a Lambda transform on the Kinesis Firehose to preprocess and structure the metrics | `bool` | `false` | no |
| <a name="input_lambda_transform_arn"></a> [lambda\_transform\_arn](#input\_lambda\_transform\_arn) | If enable\_lambda\_transform is set to true, specify a valid arn | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name for this CloudWatch Metric Stream. | `string` | `"uptrace-cloudwatch-metrics"` | no |
| <a name="input_namespace_exclude_filters"></a> [namespace\_exclude\_filters](#input\_namespace\_exclude\_filters) | An optional list of CloudWatch Metric namespaces to exclude. If set, we'll only stream metrics that are not in these namespaces. Mutually exclusive with `namespace_include_filters`. | `list(string)` | `[]` | no |
| <a name="input_namespace_include_filters"></a> [namespace\_include\_filters](#input\_namespace\_include\_filters) | An optional list of CloudWatch Metric namespaces to include. If set, we'll only stream metrics from these namespaces. Mutually exclusive with `namespace_exclude_filters`. | `list(string)` | `[]` | no |
| <a name="input_s3_backup_mode"></a> [s3\_backup\_mode](#input\_s3\_backup\_mode) | Should we only backup to S3 data that failed delivery, or all data? | `string` | `"FailedDataOnly"` | no |
| <a name="input_s3_buffer_interval"></a> [s3\_buffer\_interval](#input\_s3\_buffer\_interval) | In seconds. See https://docs.aws.amazon.com/firehose/latest/dev/create-configure.html | `number` | `400` | no |
| <a name="input_s3_buffer_size"></a> [s3\_buffer\_size](#input\_s3\_buffer\_size) | In MiB. See https://docs.aws.amazon.com/firehose/latest/dev/create-configure.html | `number` | `10` | no |
| <a name="input_s3_compression_format"></a> [s3\_compression\_format](#input\_s3\_compression\_format) | May be GZIP, Snappy, Zip, or Hadoop-Compatiable Snappy. See https://docs.aws.amazon.com/firehose/latest/dev/create-configure.html | `string` | `"GZIP"` | no |
| <a name="input_s3_failure_bucket_arn"></a> [s3\_failure\_bucket\_arn](#input\_s3\_failure\_bucket\_arn) | ARN of the S3 bucket that will store any logs that failed to be sent to Uptrace. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_uptrace_api_host"></a> [uptrace\_api\_host](#input\_uptrace\_api\_host) | If you use a Secure Tenancy or other proxy, put its schema://host[:port] here. | `string` | `"https://api.uptrace.dev"` | no |
| <a name="input_uptrace_dsn"></a> [uptrace\_dsn](#input\_uptrace\_dsn) | Your Uptrace DSN. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_metric_stream_arn"></a> [cloudwatch\_metric\_stream\_arn](#output\_cloudwatch\_metric\_stream\_arn) | n/a |
| <a name="output_cloudwatch_metric_stream_name"></a> [cloudwatch\_metric\_stream\_name](#output\_cloudwatch\_metric\_stream\_name) | n/a |
<!-- END_TF_DOCS -->