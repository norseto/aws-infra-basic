include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  vpc = include.root.inputs.vpc
  name = "${include.root.inputs.prefix}${local.vpc.name}"
}


terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=3.14.2"
}

inputs = merge(
    include.root.inputs.vpc,
    {name = local.name}
)
