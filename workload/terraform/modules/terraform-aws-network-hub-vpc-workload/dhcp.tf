# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_vpc_dhcp_options" "this" {
  domain_name_servers = ["AmazonProvidedDNS"]
  ntp_servers         = ["169.254.169.123"]
  tags                = { Name = "dhcp-options-${local.vpc_name}" }
}

resource "aws_vpc_dhcp_options_association" "this" {
  vpc_id          = aws_vpc.workload.id
  dhcp_options_id = aws_vpc_dhcp_options.this.id
}
