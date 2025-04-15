# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

#trivy:ignore:avd-aws-0178 - flow logs are optionally enabled passing the S3 bucket
resource "aws_vpc" "workload" {
  ipv4_ipam_pool_id    = var.ipam_pool_id
  ipv4_netmask_length  = var.ipam_pool_id != null ? var.vpc_layout.netmask : null
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = local.vpc_name }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "local_cidr" {
  count      = var.enable_local_subnets ? 1 : 0
  vpc_id     = aws_vpc.workload.id
  cidr_block = var.local_subnet_cidr
}
