resource "aws_config_config_rule" "required_tags" {
  name = "${var.environment}-required-tags"

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  input_parameters = jsonencode({
    tag1Key = "Environment"
    tag2Key = "Project"
    tag3Key = "Owner"
  })

  tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}
