output "tgw_id" {
  value = aws_ec2_transit_gateway.this.id
}

output "tgw_route_tables" {
  value = { for k, v in aws_ec2_transit_gateway_route_table.this : k => v.id }
}
