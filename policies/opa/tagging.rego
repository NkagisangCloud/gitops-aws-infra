# policies/tagging.rego
# Enforces that all Terraform-managed resources have required tags

package main

# Required tags that every resource must have
required_tags := {"Environment", "Project", "Owner"}

# Deny if any resource is missing required tags
deny[msg] {
  resource := input.resource_changes[_]
  resource.change.actions[_] != "delete"

  # Get the tags from the resource config
  tags := resource.change.after.tags

  # Find which required tags are missing
  missing := required_tags - {tag | tags[tag]}
  count(missing) > 0

  msg := sprintf(
    "Resource '%s' of type '%s' is missing required tags: %v",
    [resource.address, resource.type, missing]
  )
}

# Deny if tags field doesn't exist at all
deny[msg] {
  resource := input.resource_changes[_]
  resource.change.actions[_] != "delete"
  not resource.change.after.tags

  msg := sprintf(
    "Resource '%s' of type '%s' has no tags defined at all",
    [resource.address, resource.type]
  )
}
