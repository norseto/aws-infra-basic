include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  target = include.root.inputs.security_groups.internal
  sg = merge(
    local.target,
    { name : "${include.root.inputs.prefix}${local.target.name}" }
  )
}

dependency "vpc" {
  config_path = "../../vpc"
}

terraform {
  source = "tfr:///terraform-aws-modules/security-group/aws?version=4.9.0"
}

inputs = merge(
  local.sg,
  { vpc_id : dependency.vpc.outputs.vpc_id }
)
