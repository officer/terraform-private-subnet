# Required Attributes
variable "vpc_id" {
  description   = "(Required) VPC ID"
  type          = "string"
}

variable "cidr_block" {
  description   = "(Required) VPC CIDR block"
  type          = "string"
}


variable "availability_zones" {
  description   = "(Required) Availability zones"
  type          = "list"
}

# Optional attributes
variable "nat_gateway_enabled" {
  description   = "(Optional) Whether use NAT Gateway or not"
  type          = "string"
  default       = "false"
}

variable "nat_gateway_id" {
  description   = "(Optional) NAT Gateway ID. Required if nat_gateway_enabled is true"
  type          = "string"
  default       = "none"
}


variable "tags" {
  description   = "(Optional) tags"
  type          = "map"
  default       = {}
}