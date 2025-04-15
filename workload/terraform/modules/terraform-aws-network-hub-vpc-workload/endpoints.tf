# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_gateway ? 1 : 0

  vpc_id          = aws_vpc.workload.id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = [for s in merge(aws_route_table.private, aws_route_table.local) : s.id]

  tags = {
    Name = "s3-endpoint-${local.vpc_name}"
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_gateway ? 1 : 0

  vpc_id          = aws_vpc.workload.id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  route_table_ids = [for s in merge(aws_route_table.private, aws_route_table.local) : s.id]

  tags = {
    Name = "dynamodb-endpoint-${local.vpc_name}"
  }
}

resource "aws_vpc_endpoint" "this" {
  for_each          = (toset(var.vpc_endpoints))
  vpc_id            = aws_vpc.workload.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type = "Interface"
}
