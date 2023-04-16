data "aws_region" "current" {}

locals {
  region                    = data.aws_region.current.name
  default_lambda_parameters = { "BufferSizeInMBs" = 2, "BufferIntervalInSeconds" = 61 }
  lambda_parameters = merge(
    local.default_lambda_parameters,
    var.lambda_processor_parameters,
    { "LambdaArn" = "${var.lambda_transform_arn}:$LATEST" },
  )

}

resource "aws_kinesis_firehose_delivery_stream" "http_stream" {
  name        = var.name
  destination = "http_endpoint"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_s3_role.arn
    bucket_arn = var.s3_failure_bucket_arn

    buffer_size        = var.s3_buffer_size
    buffer_interval    = var.s3_buffer_interval
    compression_format = var.s3_compression_format
  }

  http_endpoint_configuration {
    url                = "${var.uptrace_api_host}/api/v1/cloudwatch/${var.uptrace_event_type}"
    name               = "uptrace"
    access_key         = var.uptrace_dsn
    role_arn           = aws_iam_role.firehose_s3_role.arn
    s3_backup_mode     = var.s3_backup_mode
    buffering_size     = var.http_buffering_size
    buffering_interval = var.http_buffering_interval

    request_configuration {
      content_encoding = "GZIP"
    }

    dynamic "processing_configuration" {
      for_each = var.lambda_transform_arn != "" ? ["allow_transform"] : []
      content {
        enabled = var.enable_lambda_transform

        processors {
          type = "Lambda"

          dynamic "parameters" {
            // use keys() to get a stable ordering
            for_each = keys(local.lambda_parameters)
            content {
              parameter_name  = parameters.value
              parameter_value = local.lambda_parameters[parameters.value]
            }
          }
        }
      }
    }

  }
}

data "aws_iam_policy_document" "firehose-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "firehose_s3_role" {
  name_prefix        = var.name
  assume_role_policy = data.aws_iam_policy_document.firehose-assume-role-policy.json
}

data "aws_iam_policy_document" "firehose_s3_policy_document" {
  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      var.s3_failure_bucket_arn,
      "${var.s3_failure_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "firehose_s3_policy" {
  name   = "firehose_s3_policy_${local.region}"
  role   = aws_iam_role.firehose_s3_role.id
  policy = data.aws_iam_policy_document.firehose_s3_policy_document.json
}

data "aws_iam_policy_document" "firehose_lambda_policy_document" {
  statement {
    actions = [
      "lambda:InvokeFunction",
      "lambda:GetFunctionConfiguration"
    ]
    resources = [
      "${var.lambda_transform_arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "firehose_lambda_policy" {
  count  = var.enable_lambda_transform ? 1 : 0
  name   = "firehose_lambda_policy_${local.region}"
  role   = aws_iam_role.firehose_s3_role.id
  policy = data.aws_iam_policy_document.firehose_lambda_policy_document.json
}