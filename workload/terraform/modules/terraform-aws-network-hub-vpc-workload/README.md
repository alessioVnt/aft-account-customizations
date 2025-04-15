# terraform-aws-vpc

This pipeline creates an AWS VPC.

VPC Layout variable explained. The module accepts the variable `vpc_layout`, that allow you to specify how to layout the subnets and their type (private or public), whether to attach the subnet to the Transit Gateway, it supports the use of AWS Ipam or to supply the CIDR block statically.

Example:
```hcl
# You can see the resulting layout from here:
# https://www.davidc.net/sites/default/subnets/subnets.html?network=192.168.0.0&mask=24&division=13.3d40

vpc_layout = {
  netmask      = 24 # in case you use IPAM, just supply the netmask, so IPAM can get the required size from the pool
  number_of_az = 3  # on how many AZ you want to span the subnets
  subnets = { # you can define as many subnet layers as you want
    application = { # the subnets will be tagged with this name, must be unique in the VPC
      type          = "private" # can "private" or "public"
      newbits       = 2 # how many bits to add the original netmask of the VPC CIDR block, in this case, the subnet will have a /26 (24 +2)
      netnum_offset = 0 # the index of the first subnet of the group
      tgw_attach    = true # we want to attach this subnet to the Transit Gateway
    }
    database = {
      type          = "private" 
      newbits       = 4 # /28 subnets
      netnum_offset = 12 
      tgw_attach    = false
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_aws.networking"></a> [aws.networking](#provider\_aws.networking) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_default_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ec2_transit_gateway_vpc_attachment_accepter.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment_accepter) | resource |
| [aws_eip.nat_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.workload_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.local](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.local](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.local](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.workload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpc_endpoint.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_ipv4_cidr_block_association.local_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association) | resource |
| [aws_availability_zones.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_ec2_transit_gateway.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | n/a | `string` | n/a | yes |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable AWS DNS hostnames | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable AWS DNS support | `bool` | `true` | no |
| <a name="input_enable_dynamodb_gateway"></a> [enable\_dynamodb\_gateway](#input\_enable\_dynamodb\_gateway) | Enables DynamoDB gateway | `bool` | `true` | no |
| <a name="input_enable_igw"></a> [enable\_igw](#input\_enable\_igw) | Enables Internet Gateway | `bool` | `false` | no |
| <a name="input_enable_ipam"></a> [enable\_ipam](#input\_enable\_ipam) | Enables AWS Ipam | `bool` | `false` | no |
| <a name="input_enable_local_subnets"></a> [enable\_local\_subnets](#input\_enable\_local\_subnets) | Enables local subnets | `bool` | `true` | no |
| <a name="input_enable_nat_gw"></a> [enable\_nat\_gw](#input\_enable\_nat\_gw) | Enables NAT gateway, this also enables Internet Gateway | `bool` | `false` | no |
| <a name="input_enable_s3_gateway"></a> [enable\_s3\_gateway](#input\_enable\_s3\_gateway) | Enables S3 gateway | `bool` | `true` | no |
| <a name="input_enable_tgw"></a> [enable\_tgw](#input\_enable\_tgw) | Enables Transit Gateway Attachment | `bool` | `true` | no |
| <a name="input_enable_tgw_accepter"></a> [enable\_tgw\_accepter](#input\_enable\_tgw\_accepter) | Enables Transit Gateway Attachment Accepter. If the Transit Gateway is set to auto accept attachments, this must be set to `false` | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_flow_logs_s3_arn"></a> [flow\_logs\_s3\_arn](#input\_flow\_logs\_s3\_arn) | S3 bucket ARN where flow logs must be written | `string` | `null` | no |
| <a name="input_ipam_pool_id"></a> [ipam\_pool\_id](#input\_ipam\_pool\_id) | ID of the Ipam from which the VPC obtain the CIDR block, required if `enable_ipam` is `true` | `string` | `null` | no |
| <a name="input_local_subnet_cidr"></a> [local\_subnet\_cidr](#input\_local\_subnet\_cidr) | CIDR block for private, non externally routeable subnets | `string` | `"100.0.0.0/16"` | no |
| <a name="input_nat_gw_one_per_az"></a> [nat\_gw\_one\_per\_az](#input\_nat\_gw\_one\_per\_az) | Create a NAT gateway per AZ | `bool` | `false` | no |
| <a name="input_tgw_association"></a> [tgw\_association](#input\_tgw\_association) | Transit Gateway Route Table IDs to associate | `string` | `null` | no |
| <a name="input_tgw_id"></a> [tgw\_id](#input\_tgw\_id) | ID of the Transit Gateway the VPC will attach on, required if `enable_tgw` is `true` | `string` | `null` | no |
| <a name="input_tgw_propagations"></a> [tgw\_propagations](#input\_tgw\_propagations) | List of Transit Gateway Route Table IDs to propagate | `list(string)` | `[]` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_vpc_endpoints"></a> [vpc\_endpoints](#input\_vpc\_endpoints) | List of VPC endpoints to enable | `list(string)` | `[]` | no |
| <a name="input_vpc_layout"></a> [vpc\_layout](#input\_vpc\_layout) | Layout of the VPC | `any` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Suffix to add to the VPC name, defaults to <account\_name>-<environment> | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

