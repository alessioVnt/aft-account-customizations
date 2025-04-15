# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "vpc_layout" {
  type        = any
  description = "Layout of the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  validation {
    condition     = var.vpc_cidr == null || can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/([0-9]|[1-2][0-9]|3[0-2]))$", var.vpc_cidr))
    error_message = "The VPC CIDR block is not valid."
  }
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Enable AWS DNS support"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Enable AWS DNS hostnames"
}

variable "vpc_name" {
  type        = string
  description = "Suffix to add to the VPC name, defaults to <account_name>-<environment>"
  default     = ""
}

variable "enable_tgw" {
  type        = bool
  default     = true
  description = "Enables Transit Gateway Attachment"
}

variable "enable_tgw_accepter" {
  type        = bool
  default     = true
  description = "Enables Transit Gateway Attachment Accepter. If the Transit Gateway is set to auto accept attachments, this must be set to `false`"
}

variable "environment" {
  type = string
}

variable "account_name" {
  type = string
}

variable "ipam_pool_id" {
  type        = string
  description = "ID of the Ipam from which the VPC obtain the CIDR block, required if `enable_ipam` is `true`"
  nullable    = true
}

variable "tgw_id" {
  type        = string
  description = "ID of the Transit Gateway the VPC will attach on, required if `enable_tgw` is `true`"
  default     = null
}

variable "tgw_association" {
  type        = string
  description = "Transit Gateway Route Table IDs to associate"
  default     = null
}

variable "tgw_propagations" {
  type        = list(string)
  description = "List of Transit Gateway Route Table IDs to propagate"
  default     = []
}

variable "flow_logs_s3_arn" {
  type        = string
  description = "S3 bucket ARN where flow logs must be written"
  default     = null
}

variable "enable_s3_gateway" {
  type        = bool
  default     = true
  description = "Enables S3 gateway"
}

variable "enable_dynamodb_gateway" {
  type        = bool
  default     = true
  description = "Enables DynamoDB gateway"
}

variable "enable_local_subnets" {
  type        = bool
  default     = true
  description = "Enables local subnets"
}

variable "local_subnet_cidr" {
  type        = string
  default     = "100.0.0.0/16"
  description = "CIDR block for private, non externally routeable subnets"
}

variable "enable_igw" {
  type        = bool
  default     = false
  description = "Enables Internet Gateway"
}

variable "enable_nat_gw" {
  type        = bool
  default     = false
  description = "Enables NAT gateway, this also enables Internet Gateway"
}

variable "nat_gw_one_per_az" {
  type        = bool
  default     = false
  description = "Create a NAT gateway per AZ"
}

variable "vpc_endpoints" {
  type        = list(string)
  default     = []
  description = "List of VPC endpoints to enable"
}
