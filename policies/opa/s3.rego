# policies/s3.rego
# Enforces that no S3 buckets are public

package main

# Deny public ACL on S3 buckets
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket"
  resource.change.actions[_] != "delete"

  acl := resource.change.after.acl
  acl == "public-read"

  msg := sprintf(
    "S3 bucket '%s' has ACL set to 'public-read'. Public buckets are not allowed.",
    [resource.address]
  )
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket"
  resource.change.actions[_] != "delete"

  acl := resource.change.after.acl
  acl == "public-read-write"

  msg := sprintf(
    "S3 bucket '%s' has ACL set to 'public-read-write'. Public buckets are not allowed.",
    [resource.address]
  )
}

# Deny if public access block is not enabled
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_public_access_block"
  resource.change.actions[_] != "delete"

  resource.change.after.block_public_acls == false

  msg := sprintf(
    "S3 bucket public access block '%s' must have block_public_acls set to true.",
    [resource.address]
  )
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_public_access_block"
  resource.change.actions[_] != "delete"

  resource.change.after.block_public_policy == false

  msg := sprintf(
    "S3 bucket public access block '%s' must have block_public_policy set to true.",
    [resource.address]
  )
}

