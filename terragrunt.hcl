# Make the AWS region a reusable variable within the configuration
locals {
  config = yamldecode(file("${find_in_parent_folders("config.yaml")}"))
  globals = yamldecode(file("${find_in_parent_folders("globals.yaml")}"))
  prefix = length(local.globals.global.environ) > 0 ? "${local.globals.global.environ}-" : ""
  aws_account_id = get_aws_account_id()
}

#=========================================================
#  Remote Backend. Please Change for your needs.
#=========================================================
# AWS
remote_state {
  backend = "s3"
  config = {
    region         = local.config.aws.default_region
    bucket         = "${local.prefix}${local.config.aws.backend_bucket}-${local.aws_account_id}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "${local.prefix}${local.config.aws.backend_lock}-${local.aws_account_id}"
    encrypt        = true
  }
}

#=========================================================
#  Provider Generation. Please Change for your needs.
#=========================================================
generate "provider" {
  path      = "generated_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
#---------------------------------------------------------
# AWS
terraform {
  backend "s3" {}
}
provider "aws" {
  region  = "${local.config.aws.default_region}"
  default_tags {
    tags = {
      Environment = "${local.globals.global.environ}"
      Terraform = "true"
   }
  }
}
EOF
}

inputs = merge(
  {
    prefix: "${local.prefix}"
    aws_account_id: local.aws_account_id
  },
  local.globals
)
