package main

required_tags := {"Environment", "Project", "Owner"}

# Resource types that do not support tags in AWS
untaggable_resources := {
  "aws_config_configuration_recorder",
  "aws_config_configuration_recorder_status",
  "aws_config_delivery_channel",
  "aws_s3_bucket_policy",
  "aws_s3_bucket_public_access_block",
  "aws_iam_role_policy_attachment",
  "aws_iam_policy_attachment"
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.change.actions[_] != "delete"

  # Skip resources that don't support tags
  not untaggable_resources[resource.type]

  tags := resource.change.after.tags
  missing := required_tags - {tag | tags[tag]}
  count(missing) > 0

  msg := sprintf(
    "Resource '%s' of type '%s' is missing required tags: %v",
    [resource.address, resource.type, missing]
  )
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.change.actions[_] != "delete"

  # Skip resources that don't support tags
  not untaggable_resources[resource.type]

  not resource.change.after.tags

  msg := sprintf(
    "Resource '%s' of type '%s' has no tags defined at all",
    [resource.address, resource.type]
  )
}
