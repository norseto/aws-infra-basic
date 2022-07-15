include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  vpc = merge(
    include.root.inputs.vpc,
    { name = "${include.root.inputs.prefix}${include.root.inputs.vpc.name}" }
  )
}


terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=3.14.2"
}

inputs = merge(
  local.vpc
)
