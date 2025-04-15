# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  private_subnets_layouts = { for k, v in var.vpc_layout.subnets : k => v if v.type == "private" }
  public_subnets_layouts  = { for k, v in var.vpc_layout.subnets : k => v if v.type == "public" }
  abc                     = ["a", "b", "c"]
  vpc_name                = var.vpc_name != "" ? var.vpc_name : "${var.account_name}-${var.environment}"

  private_subnets = { for s in flatten([for i in range(var.vpc_layout.number_of_az) : [
    for k, v in local.private_subnets_layouts : {
      name         = k
      index        = i
      netnum       = v.netnum_offset + i
      newbits      = v.newbits
      type         = v.type
      tgw_attach   = lookup(v, "tgw_attach", false)
      route_to_tgw = lookup(v, "route_to_tgw", false)
    }
    ]
  ]) : "${s.name}-${s.index + 1}" => s }

  public_subnets = { for s in flatten([for i in range(var.vpc_layout.number_of_az) : [
    for k, v in local.public_subnets_layouts : {
      name    = k
      index   = i
      netnum  = v.netnum_offset + i
      newbits = v.newbits
      type    = v.type
    }
    ]
  ]) : "${s.name}-${s.index + 1}" => s }

  local_subnets = var.enable_local_subnets ? { for s in flatten([
    for s in [for i in range(var.vpc_layout.number_of_az) : [
      {
        name    = "local"
        index   = i
        netnum  = i
        newbits = 2
        type    = "local"
      }
  ]] : s]) : "${s.name}-${s.index + 1}" => s } : {}

  nat_gw_count     = var.enable_nat_gw ? var.nat_gw_one_per_az ? var.vpc_layout.number_of_az : 1 : 0
  tgw_propagations = var.enable_tgw ? var.tgw_propagations : []
}
