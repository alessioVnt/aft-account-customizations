data "aws_region" "current" {}

locals {
  tgw_route_tables = { for rt in var.route_tables : rt => rt }

  sharing_to_principals = { for ou in var.sharing_to_principals : ou => ou }

  amazon_side_asns = {
    "us-east-1"      = 64526
    "us-east-2"      = 64527
    "us-west-1"      = 64528
    "us-west-2"      = 64529
    "eu-west-1"      = 64530
    "eu-west-2"      = 64531
    "eu-west-3"      = 64532
    "eu-central-1"   = 64533
    "eu-south-1"     = 64534
    "ca-central-1"   = 64535
    "ap-northeast-1" = 64536
    "ap-northeast-2" = 64537
    "ap-south-1"     = 64538
    "ap-southeast-1" = 64539
    "ap-southeast-2" = 64540
    "sa-east-1"      = 64541
  }
}
