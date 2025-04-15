# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.workload.id
  cidr_block        = cidrsubnet(aws_vpc.workload.cidr_block, each.value.newbits, each.value.netnum)
  availability_zone = data.aws_availability_zones.current.names[each.value.index]

  tags = {
    Name = "${local.vpc_name}-${each.value.name}-${data.aws_region.current.name}${local.abc[each.value.index]}"
    type = "private"
  }

  lifecycle {
    ignore_changes = [cidr_block, tags]
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id            = aws_vpc.workload.id
  cidr_block        = cidrsubnet(aws_vpc.workload.cidr_block, each.value.newbits, each.value.netnum)
  availability_zone = data.aws_availability_zones.current.names[each.value.index]

  tags = {
    Name = "${local.vpc_name}-${each.value.name}-${data.aws_region.current.name}${local.abc[each.value.index]}"
    type = "public"
  }

  lifecycle {
    ignore_changes = [cidr_block, tags]
  }
}

resource "aws_subnet" "local" {
  for_each = local.local_subnets

  vpc_id            = aws_vpc.workload.id
  cidr_block        = cidrsubnet(var.local_subnet_cidr, each.value.newbits, each.value.netnum)
  availability_zone = data.aws_availability_zones.current.names[each.value.index]

  tags = {
    Name = "${local.vpc_name}-${each.value.name}-${data.aws_region.current.name}${local.abc[each.value.index]}"
    type = "local"
  }

  lifecycle {
    ignore_changes = [cidr_block, tags]
  }

  depends_on = [aws_vpc_ipv4_cidr_block_association.local_cidr]
}
