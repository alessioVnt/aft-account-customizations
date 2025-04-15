# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_organizations_organization" "current" {
  provider = aws.aft_deployment
}

locals {
  tgw_route_tables = [
    "workload_dev",
    "workload_tst",
    "workload_prd",
    "infrastructure"
  ]
}

module "tgw_eu_west_1" {
  source = "./modules/terraform-aws-tgw"
  providers = {
    aws = aws
  }

  name         = "eu_west_1"
  route_tables = local.tgw_route_tables

  sharing_to_principals = [
    data.aws_organizations_organization.current.arn # sharing the TGW with the whole org
  ]
}