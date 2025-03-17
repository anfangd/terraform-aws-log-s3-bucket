provider "aws" {
  region = "us-west-2"
}

run "test_variables" {
  command = plan
  variables {
    env     = "sandbox"
    product = "platform"
    usage   = "logs"
    region  = "us-west-2"
    suffix  = "000"

    log_type = "access"

    enable_force_destroy = false
    # tags = {}

    enable_object_lock = false

    sse_algorithm = "AES256"
    # enable_sse_bucket_key =
    # kms_master_key_id =


    enable_lifecycle = false
    # lifecycle_filter_prefix =
    # lifecycle_pattern

    # logging_target_bucket =
    # logging_target_prefix =

    # iam_policy_name =
  }
  assert {
    condition     = local.s3.bucket_name == "${var.env}-${var.product}-${var.log_type}-${var.usage}-${local.region_code[var.region]}-${var.suffix}"
    error_message = "The environment must be sandbox"
  }
  assert {
    condition     = local.s3.tags == merge(var.tags, local.tags)
    error_message = "The product must be platform"
  }
  assert {
    condition     = local.object_lock_pattern["default"] == local.object_lock_pattern["default"]
    error_message = "The region must be us-west-2"
  }
}
