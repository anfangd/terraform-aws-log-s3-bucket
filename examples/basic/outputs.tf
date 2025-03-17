output "tfstate" {
  description = "output of tfstate module"
  value = {
    s3  = module.tfstate.s3
    iam = module.tfstate.iam
  }
}
