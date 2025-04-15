# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw" {
  count = var.enable_tgw ? 1 : 0

  subnet_ids                                      = [for i, s in local.private_subnets : aws_subnet.private[i].id if s.tgw_attach]
  transit_gateway_id                              = var.tgw_id
  vpc_id                                          = aws_vpc.workload.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = { Name = "${local.vpc_name}-${data.aws_ec2_transit_gateway.tgw[0].tags["Name"]}-attachment" }

  # workaround for this issue: https://github.com/hashicorp/terraform-provider-aws/issues/8383
  lifecycle {
    ignore_changes = [
      transit_gateway_default_route_table_association,
      transit_gateway_default_route_table_propagation
    ]
  }
}

data "aws_ec2_transit_gateway" "tgw" {
  count = var.enable_tgw && var.enable_tgw_accepter ? 1 : 0

  provider = aws.networking
  id       = var.tgw_id
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "tgw" {
  count    = var.enable_tgw && var.enable_tgw_accepter ? 1 : 0
  provider = aws.networking

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw[0].id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "${local.vpc_name}-${data.aws_ec2_transit_gateway.tgw[0].tags["Name"]}-attachment"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  provider = aws.networking
  count    = var.enable_tgw ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment_accepter.tgw[0].id
  transit_gateway_route_table_id = var.tgw_association
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  provider = aws.networking
  for_each = var.enable_tgw ? { for p in local.tgw_propagations : p => p } : {}

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment_accepter.tgw[0].id
  transit_gateway_route_table_id = each.value
}
