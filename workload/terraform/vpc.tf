# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.  
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at 
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "vpc_workload_eu_west_1" {
  source = "./modules/terraform-aws-network-hub-vpc-workload"
  providers = {
    aws            = aws.eu_west_1
    aws.networking = aws.network_eu_west_1
  }
  for_each = local.vpc_parameters_eu_west_1

  vpc_layout           = local.vpc_layouts[local.vpc_parameters_eu_west_1[each.key].vpc_layout]
  vpc_cidr             = try(local.vpc_parameters_eu_west_1[each.key].vpc_cidr, null)
  vpc_name             = each.key
  ipam_pool_id = null
  environment          = local.environment
  account_name         = local.account_name
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_local_subnets = try(local.vpc_parameters_eu_west_1[each.key].enable_local_subnets, false)

  enable_tgw      = true
  tgw_id          = nonsensitive(data.aws_ssm_parameter.tgw_eu_west_1.value)
  tgw_association = nonsensitive(data.aws_ssm_parameter.tgw_rt_eu_west_1["workload_${local.environment}"].value)
  # propagate this VPC in the following route tables
  tgw_propagations = [
    nonsensitive(data.aws_ssm_parameter.tgw_rt_eu_west_1["workload_${local.environment}"].value),
    nonsensitive(data.aws_ssm_parameter.tgw_rt_eu_west_1["infrastructure"].value)
  ]
  enable_s3_gateway       = true
  enable_dynamodb_gateway = true
  enable_igw              = true
  enable_nat_gw           = true
  nat_gw_one_per_az       = false
}