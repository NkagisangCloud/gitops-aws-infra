output "config_rule_name" {
  description = "Name of the AWS Config tagging rule"
  value       = aws_config_config_rule.required_tags.name
}

output "config_rule_arn" {
  description = "ARN of the AWS Config tagging rule"
  value       = aws_config_config_rule.required_tags.arn
}
