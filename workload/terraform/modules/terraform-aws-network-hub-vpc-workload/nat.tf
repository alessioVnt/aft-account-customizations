# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_eip" "nat_gw" {
  count  = local.nat_gw_count
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  count         = local.nat_gw_count
  allocation_id = aws_eip.nat_gw[count.index].id
  subnet_id     = values(aws_subnet.public)[count.index].id
  depends_on    = [aws_internet_gateway.gw]
}
