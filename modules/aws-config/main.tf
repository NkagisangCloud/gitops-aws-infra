# Use existing Config recorder — AWS only allows 1 per account per region
# Just deploy the tagging rule per environment

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
