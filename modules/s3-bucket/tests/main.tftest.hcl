run "apply_s3_bucket" {
  command = plan
  variables {
    bucket_name         = "my-bucket-xxxxyyyyy1111122223333"
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
    condition     = var.bucket_name == "my-bucket-xxxxyyyyy1111122223333"
    error_message = "The bucket name must be my-bucket-xxxxyyyyy1111122223333"
  }
}
