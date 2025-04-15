# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_flow_log" "workload_s3" {
  count = var.flow_logs_s3_arn != null ? 1 : 0

  log_destination_type = "s3"
  log_destination      = var.flow_logs_s3_arn
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.workload.id

  destination_options {
    file_format                = "plain-text"
    hive_compatible_partitions = false
    per_hour_partition         = false
  }

  tags = {
    Name = "${local.vpc_name}-flowlogs"
  }
}