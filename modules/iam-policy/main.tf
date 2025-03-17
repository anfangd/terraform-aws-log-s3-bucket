locals {
  s3 = {
    policy = {
      bucket_operation = {
        actions = [
          "s3:ListBucket"
        ]
        resources = [for v in var.s3 : "arn:aws:s3:::${v.bucket_name}"]
      }
      object_operation = {
        actions = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        resources = [for v in var.s3 : "arn:aws:s3:::${v.bucket_name}/${v.key_prefix}*"]
      }
    }
  }
}

data "aws_iam_policy_document" "this" {

  dynamic "statement" {
    for_each = local.s3.policy

    content {
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}


resource "aws_iam_policy" "this" {
  name        = "${var.policy_name}-policy"
  description = "IAM policy for ${var.policy_name}"
  policy      = data.aws_iam_policy_document.this.json
}
