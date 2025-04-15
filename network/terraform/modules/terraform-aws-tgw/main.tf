resource "aws_ec2_transit_gateway" "this" {
  description                     = "Transit Gateway ${var.name}-${data.aws_region.current.name}"
  amazon_side_asn                 = local.amazon_side_asns[data.aws_region.current.name]
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  tags                            = { Name = "tgw-${var.name}-${data.aws_region.current.name}" }
}

resource "aws_ec2_transit_gateway_route_table" "this" {
  for_each = local.tgw_route_tables

  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags               = { Name = "tgw-${var.name}-${each.key}-rtb" }
}

resource "aws_ram_resource_share" "tgw" {
  name                      = "tgw-${var.name}-share"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "tgw" {
  resource_arn       = aws_ec2_transit_gateway.this.arn
  resource_share_arn = aws_ram_resource_share.tgw.arn
}

resource "aws_ram_principal_association" "tgw" {
  for_each           = local.sharing_to_principals
  principal          = each.key
  resource_share_arn = aws_ram_resource_share.tgw.arn
}