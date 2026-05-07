variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
}

variable "owner" {
  description = "Owner tag value"
  type        = string
}
