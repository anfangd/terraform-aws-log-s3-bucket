module "tfstate" {
  source = "../../"

  env     = "sandbox"
  product = "platform"
  usage   = "tfstate"
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
