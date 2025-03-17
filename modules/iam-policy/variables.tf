variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
  nullable    = false
  # default     =

  validation {
    condition     = length(var.policy_name) >= 3
    error_message = "The policy name must not be empty"
  }
}

variable "s3" {
  description = "List of S3 bucket to allow access"
  type = list(object({
    bucket_name = string           # The bucket name to allow access
    key_prefix  = optional(string) # The key prefix to allow access
  }))
  default = [{
    bucket_name = ""
  }]

  validation {
    condition     = alltrue([for v in var.s3 : length(v.bucket_name) >= 3])
    error_message = "Each S3 bucket name must be at least 3 characters long"
  }
}
