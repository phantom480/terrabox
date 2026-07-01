variable "sg_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

# using any here instead of a strict object type so a rule can pass
# either cidr_blocks or source_security_group_id without needing both keys
variable "ingress_rules" {
  type    = list(any)
  default = []
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
