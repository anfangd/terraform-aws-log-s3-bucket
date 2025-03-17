provider "aws" {
  region = "us-west-2"
}

run "test_iam_policy" {
  variables {
    policy_name = "xxx"
    s3 = [{
      bucket_name = "xxx"
      key_prefix  = "yyy"
    }]
  }

  assert {
    condition     = aws_iam_policy.this.name == "xxx-policy"
    error_message = "The IAM policy must have the correct name"
  }
}
