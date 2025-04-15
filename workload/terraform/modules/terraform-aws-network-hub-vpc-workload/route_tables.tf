# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_route_table" "private" {
  for_each = local.private_subnets_layouts

  vpc_id = aws_vpc.workload.id

  dynamic "route" {
    for_each = try(each.value.route_to_tgw, false) ? [1] : []
    content {
      cidr_block         = "0.0.0.0/0"
      transit_gateway_id = aws_ec2_transit_gateway_vpc_attachment_accepter.tgw[0].transit_gateway_id
    }
  }

  tags = { Name = "${local.vpc_name}-${each.key}-rtb" }
  # lifecycle {
  #   ignore_changes = [route]
  # }
}

resource "aws_route_table_association" "private" {
  for_each       = local.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.value.name].id
}

resource "aws_route_table" "public" {
  for_each = local.public_subnets_layouts

  vpc_id = aws_vpc.workload.id
  route {
    cidr_block         = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw[0].id
  }

  tags = { Name = "${local.vpc_name}-${each.key}-rtb" }

  # lifecycle {
  #   ignore_changes = [route]
  # }
}

resource "aws_route_table_association" "public" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.value.name].id
}

resource "aws_route_table" "local" {
  for_each = local.local_subnets

  vpc_id = aws_vpc.workload.id
  tags   = { Name = "${local.vpc_name}-${each.value.name}-rtb-${local.abc[each.value.index]}" }
  # lifecycle {
  #   ignore_changes = [route]
  # }
}

resource "aws_route_table_association" "local" {
  for_each = local.local_subnets

  subnet_id      = aws_subnet.local[each.key].id
  route_table_id = aws_route_table.local[each.key].id
}


