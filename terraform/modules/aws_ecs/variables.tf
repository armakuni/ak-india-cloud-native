variable "prefix" {
  type        = string
  description = "APP Prefix"
}
variable "app_name" {
  description = "Application Name"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC IDs where ECS cluster resides"
}

variable "private_cidr_block" {
  type        = list(string)
  description = "CIDRs block fro private a subnet"
}

variable "enable_blue_green" {
  type        = bool
  description = "Enable blue green deployment or not"
  default     = false
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs of public"
}

variable "load_balancer_name" {
  type        = string
  description = "Load balancer name"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Subnet ID of private"
}

variable "aws_region" {
  type        = string
  description = "Region"
  default     = "eu-west-2"
}

variable "ecr_image_url" {
  type        = string
  description = "ECR image for Flask APP"
}

variable "elb_target_group_arn" {
  type        = string
  description = "ARN of elastic load balancer target group"
}

variable "load_balancer_security_group_id" {
  type        = string
  description = "Security group ID of load balancer"
}




