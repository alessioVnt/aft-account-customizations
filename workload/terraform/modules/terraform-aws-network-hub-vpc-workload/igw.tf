# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_internet_gateway" "gw" {
  count  = var.enable_igw || var.enable_nat_gw ? 1 : 0
  vpc_id = aws_vpc.workload.id
}
