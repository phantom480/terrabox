resource "aws_security_group" "this" {
  name        = var.sg_name
  description = "Security group for ${var.sg_name}"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.sg_name
  }
}

# ingress rules - each one is either cidr based or from another sg, not both
resource "aws_security_group_rule" "ingress" {
  count             = length(var.ingress_rules)
  type              = "ingress"
  security_group_id = aws_security_group.this.id

  description = lookup(var.ingress_rules[count.index], "description", null)
  from_port   = var.ingress_rules[count.index].from_port
  to_port     = var.ingress_rules[count.index].to_port
  protocol    = var.ingress_rules[count.index].protocol

  cidr_blocks              = length(lookup(var.ingress_rules[count.index], "cidr_blocks", [])) > 0 ? var.ingress_rules[count.index].cidr_blocks : null
  source_security_group_id = lookup(var.ingress_rules[count.index], "source_security_group_id", null)
}

# Egress Rules
resource "aws_security_group_rule" "egress" {
  count             = length(var.egress_rules)
  type              = "egress"
  security_group_id = aws_security_group.this.id

  description = lookup(var.egress_rules[count.index], "description", null)
  from_port   = var.egress_rules[count.index].from_port
  to_port     = var.egress_rules[count.index].to_port
  protocol    = var.egress_rules[count.index].protocol
  cidr_blocks = var.egress_rules[count.index].cidr_blocks
}
