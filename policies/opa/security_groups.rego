# policies/security_groups.rego
# Enforces that no security group opens SSH (port 22) to the world

package main

# Deny SSH open to 0.0.0.0/0
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_security_group"
  resource.change.actions[_] != "delete"

  ingress := resource.change.after.ingress[_]
  ingress.from_port <= 22
  ingress.to_port >= 22
  ingress.cidr_blocks[_] == "0.0.0.0/0"

  msg := sprintf(
    "Security group '%s' allows SSH (port 22) from 0.0.0.0/0. This is not allowed.",
    [resource.address]
  )
}

# Deny SSH open to ::/0 (IPv6)
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_security_group"
  resource.change.actions[_] != "delete"

  ingress := resource.change.after.ingress[_]
  ingress.from_port <= 22
  ingress.to_port >= 22
  ingress.ipv6_cidr_blocks[_] == "::/0"

  msg := sprintf(
    "Security group '%s' allows SSH (port 22) from ::/0 (IPv6). This is not allowed.",
    [resource.address]
  )
}

# Deny RDP (port 3389) open to the world
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_security_group"
  resource.change.actions[_] != "delete"

  ingress := resource.change.after.ingress[_]
  ingress.from_port <= 3389
  ingress.to_port >= 3389
  ingress.cidr_blocks[_] == "0.0.0.0/0"

  msg := sprintf(
    "Security group '%s' allows RDP (port 3389) from 0.0.0.0/0. This is not allowed.",
    [resource.address]
  )
}

