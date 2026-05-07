output "vpc_id" {
  description = "Dev VPC ID"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "Dev Subnet ID"
  value       = module.vpc.subnet_id
}
