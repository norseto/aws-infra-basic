include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  target = include.root.inputs.security_groups.server
  sg = merge(
    local.target,
    {
      name : "${include.root.inputs.prefix}${local.target.name}"
    }
  )
}

dependency "external_sg" {
  config_path = "../external-web"
}

terraform {
  source = "tfr:///terraform-aws-modules/security-group/aws?version=4.9.0"
}

inputs = merge(
  local.sg,
  {
    ingress_with_source_security_group_id : [
      {
        rule : "all-all"
        source_security_group_id : dependency.external_sg.outputs.security_group_id
      }
    ],
    vpc_id : dependency.external_sg.outputs.security_group_vpc_id
  }
)
