variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}
variable "vpc_cidr_block" {
  type        = string
  description = "The IP range to use for VPC"
  default     = "10.0.0.0/16"
}
