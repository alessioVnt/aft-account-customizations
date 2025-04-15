variable "name" {
  type        = string
  description = "Name of the Transit Gateway"
}

variable "route_tables" {
  type        = list(string)
  description = "List of routing table names to create and associate with the Transit Gateway"
}

variable "sharing_to_principals" {
  type        = list(string)
  description = "List of principals to share the Transit Gateway with"
}