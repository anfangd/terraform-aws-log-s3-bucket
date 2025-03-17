provider "aws" {
  region = "us-west-2"
}

run "test_bucket_default" {
  command = plan
  variables {
    bucket_name = "my-bucket"
    # enable_force_destroy = false
    # tags = {
    #   Name = "my-bucket"
    # }
    # enable_versioning_mfa_delete = null
    # versioning_mfa = null
    # enable_object_lock = null
    # object_lock_mode = null
    # object_lock_days = null
    # object_lock_years = null
    # sse_algorithm = null
    # enable_sse_bucket_key = null
    # sse_kms_master_key_id = null
    # enable_life_cycle_rule = null
    # lifecycle_filter_prefix = null
    # lifecycle_rule_transition_to_standard_ia_days = null
    # lifecycle_rule_transition_to_glacier_days = null
    # lifecycle_rulr_expire_days = null
    # logging_target_bucket = null
    # logging_target_prefix = null
  }
  assert {
    condition     = var.bucket_name == "my-bucket"
    error_message = "The bucket name must be my-bucket"
  }
}

run "test_bucket_custom_1" {
  command = plan
  variables {
    bucket_name          = "my-bucket"
    enable_force_destroy = false
    tags = {
      Name = "my-bucket"
    }
    enable_versioning_mfa_delete                  = false
    versioning_mfa                                = null
    enable_object_lock                            = true
    object_lock_mode                              = "COMPLIANCE"
    object_lock_days                              = 1
    object_lock_years                             = null
    sse_algorithm                                 = "AES256"
    enable_sse_bucket_key                         = null
    sse_kms_master_key_id                         = null
    enable_lifecycle                              = true
    lifecycle_filter_prefix                       = "logs"
    lifecycle_rule_transition_to_standard_ia_days = 30
    lifecycle_rule_transition_to_glacier_days     = 60
    lifecycle_rule_expire_days                    = 90
    logging_target_bucket                         = null
    logging_target_prefix                         = null
  }
  assert {
    condition     = var.bucket_name == "my-bucket"
    error_message = "The bucket name must be my-bucket"
  }
}

run "test_bucket_custom_2" {
  command = plan
  variables {
    bucket_name = "my-bucket"
    # enable_force_destroy = false
    # tags = {
    #   Name = "my-bucket"
    # }
    # enable_versioning_mfa_delete = null
    # versioning_mfa = null
    # enable_object_lock = null
    # object_lock_mode = null
    # object_lock_days = null
    # object_lock_years = null
    # sse_algorithm = null
    # enable_sse_bucket_key = null
    # sse_kms_master_key_id = null
    # enable_life_cycle_rule = null
    # lifecycle_filter_prefix = null
    # lifecycle_rule_transition_to_standard_ia_days = null
    # lifecycle_rule_transition_to_glacier_days = null
    # lifecycle_rulr_expire_days = null
    # logging_target_bucket = null
    # logging_target_prefix = null
  }
  assert {
    condition     = var.bucket_name == "my-bucket"
    error_message = "The bucket name must be my-bucket"
  }
}

run "test_bucket_error_1" {
  command = plan
  variables {
    bucket_name = ""
  }
  expect_failures = [var.bucket_name]
}

run "test_bucket_error_2" {
  command = plan
  variables {
    bucket_name = join("", [for i in range(64) : "x"])
  }
  expect_failures = [var.bucket_name]
}

run "test_null_error_1" {
  command = plan
  variables {
    bucket_name                                   = ""
    enable_force_destroy                          = null
    tags                                          = null
    enable_versioning_mfa_delete                  = null
    versioning_mfa                                = null
    enable_object_lock                            = null
    object_lock_mode                              = null
    object_lock_days                              = null
    object_lock_years                             = null
    sse_algorithm                                 = null
    enable_sse_bucket_key                         = null
    sse_kms_master_key_id                         = null
    enable_lifecycle                              = null
    lifecycle_filter_prefix                       = null
    lifecycle_rule_transition_to_standard_ia_days = null
    lifecycle_rule_transition_to_glacier_days     = null
    lifecycle_rule_expire_days                    = null
    logging_target_bucket                         = null
    logging_target_prefix                         = null
  }
  expect_failures = [
    var.bucket_name,
  ]
}
