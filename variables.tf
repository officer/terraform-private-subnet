variable "vpc_id" {
  description = "VPC ID"
  type = "string"
}

variable "cidr_block" {
  description = "VPC CIDR block"
  type = "string"
}


variable "availability_zones" {
    description = "Availability zones"
    type = "list"
}

variable "nat_gateway_enabled" {
  description = "Use NAT Gateway or not"
  type = "string"
  default = "false"
}

variable "nat_gateway_id" {
  description = "NAT Gateway ID"
  type = "string"
}


variable "tags" {
  description = "tags"
  type = "map"
}