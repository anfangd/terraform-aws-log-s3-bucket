locals {
  terraform = {
    module = {
      name    = "log-s3-bucket"
      version = "v0.0.1"
    }
  }
  region_code = {
    "us-east-1"      = "ue1",
    "us-east-2"      = "ue2",
    "us-west-1"      = "uw1",
    "us-west-2"      = "uw2",
    "ap-south-1"     = "as1",
    "ap-northeast-1" = "an1",
    "ap-northeast-2" = "an2",
    "ap-northeast-3" = "an3",
    "ap-southeast-1" = "as1",
    "ap-southeast-2" = "as2",
    "ap-southeast-3" = "as3",
    "ca-central-1"   = "cc1",
    "eu-central-1"   = "ec1",
    "eu-west-1"      = "ew1",
    "eu-west-2"      = "ew2",
    "eu-west-3"      = "ew3",
    "eu-north-1"     = "en1",
    "sa-east-1"      = "se1"
  }
  tags = {
    TfModuleName    = local.terraform.module.name
    TfModuleVersion = local.terraform.module.version
  }
  object_lock_pattern = {
    default = {
      mode  = null
      days  = null
      years = null
    }
    compliance = {
      mode  = "COMPLIANCE"
      days  = 1
      years = null
    }
    governance = {
      mode  = "GOVERNANCE"
      days  = 1
      years = null
    }
  }
  lifecycle_pattern = {
    default = {
      transition_to_standard_ia_days = 60
      transition_to_glacier_days     = 90
      expire_days                    = 365 + 30
    }
    short = {
      transition_to_standard_ia_days = 30
      transition_to_glacier_days     = 60
      expire_days                    = 365
    }
    long = {
      transition_to_standard_ia_days = 90
      transition_to_glacier_days     = 120
      expire_days                    = 365 + 60
    }
  }
  log_storage = {
    name = (var.log_type == "awswaf" ?
      "aws-waf-logs-${var.env}-${var.product}-${var.usage}-${local.region_code[var.region]}-${var.suffix}"
      : "${var.env}-${var.product}-${var.log_type}-${var.usage}-${local.region_code[var.region]}-${var.suffix}"
    )
  }
  s3 = {
    bucket_name = local.log_storage.name
    tags        = merge(var.tags, local.tags)
    lifecycle   = local.lifecycle_pattern[var.lifecycle_pattern == null ? "default" : var.lifecycle_pattern]
    object_lock = (
      can(regex("audit", var.log_type)) ? local.object_lock_pattern["governance"] :
      can(regex("awswaf|security", var.log_type)) ? local.object_lock_pattern["compliance"] :
      local.object_lock_pattern["default"]
    )
  }
  iam_policy = {
    policy_name = try(var.custom_iam_policy_name, null) != null ? var.custom_iam_policy_name : "${var.env}-${var.product}-allow-s3-put-${var.log_type}-${var.usage}"
  }
}

# --- Amazon S3 ---

module "s3" {
  source = "./modules/s3-bucket"
  # version = "~> 0.0.1"

  bucket_name          = local.s3.bucket_name
  enable_force_destroy = var.enable_force_destroy
  tags                 = local.s3.tags

  # enable_versioning_mfa_delete = "Disabled"
  # versioning_mfa               = null

  enable_object_lock = var.enable_object_lock
  object_lock_mode   = local.s3.object_lock.mode
  object_lock_days   = local.s3.object_lock.days
  object_lock_years  = local.s3.object_lock.years

  sse_algorithm         = var.sse_algorithm
  enable_sse_bucket_key = var.enable_sse_bucket_key
  sse_kms_master_key_id = var.kms_master_key_id

  enable_lifecycle                              = var.enable_lifecycle
  lifecycle_filter_prefix                       = var.lifecycle_filter_prefix
  lifecycle_rule_transition_to_standard_ia_days = local.s3.lifecycle.transition_to_standard_ia_days
  lifecycle_rule_transition_to_glacier_days     = local.s3.lifecycle.transition_to_glacier_days
  lifecycle_rule_expire_days                    = local.s3.lifecycle.expire_days

  logging_target_bucket = var.logging_target_bucket
  logging_target_prefix = var.logging_target_prefix
}

# --- IAM Policy ---

module "iam_policy" {
  source = "./modules/iam-policy"

  policy_name = local.iam_policy.policy_name
  s3 = [{
    bucket_name = local.s3.bucket_name
    key_prefix  = ""
  }]
}
