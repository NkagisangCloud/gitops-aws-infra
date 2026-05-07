variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "environment" { type = string }
variable "project_name" { type = string }
variable "vpc_cidr"     { type = string }
variable "owner"        { type = string }
