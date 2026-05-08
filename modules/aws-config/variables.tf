# modules/aws-config/variables.tf

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name for tagging"
  type        = string
  default     = "gitops-aws-infra"
}

variable "owner" {
  description = "Owner name for tagging"
  type        = string
  default     = "NkagisangCloud"
}

variable "config_logs_bucket_prefix" {
  description = "Prefix for the S3 bucket that stores AWS Config logs"
  type        = string
  default     = "aws-config-logs"
}
