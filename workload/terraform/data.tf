data "aws_caller_identity" "current" {}
data "aws_caller_identity" "context" {}
data "aws_region" "current" {}

data "aws_ssm_parameter" "environment" {
  name = "/aft/account-request/custom-fields/environment"
}

data "aws_ssm_parameter" "account_name" {
  name = "/aft/account-request/custom-fields/account_name"
}

data "aws_ssm_parameter" "aft_deployment_account_id" {
  provider = aws.aft_deployment_primary_region
  name     = "/aft/account/aft-management/account-id"
}

data "aws_region" "primary" {
  provider = aws.aft_deployment_primary_region
}

data "aws_ssm_parameter" "vpc_parameters_eu_west_1" {
  name = "/aft/account-request/custom-fields/vpc_parameters_eu_west_1"
}

# network main = eu-west-1
data "aws_ssm_parameter" "tgw_eu_west_1" {
  provider = aws.network_eu_west_1
  name     = "/tgw/eu-west-1/tgw_id"
}

data "aws_ssm_parameter" "tgw_rt_eu_west_1" {
  for_each = { for r in local.tgw_route_tables : r => r }
  provider = aws.network_eu_west_1
  name     = "/tgw/eu-west-1/route-tables/${each.key}"
}
locals {
  environments = ["dev", "tst", "prd"]
  tgw_route_tables = [
    "workload_dev",
    "workload_tst",
    "workload_prd",
    "infrastructure"
  ]
  environment              = nonsensitive(data.aws_ssm_parameter.environment.value)
  account_name             = nonsensitive(data.aws_ssm_parameter.account_name.value)
  vpc_parameters_eu_west_1 = jsondecode(nonsensitive(data.aws_ssm_parameter.vpc_parameters_eu_west_1.value))
}
