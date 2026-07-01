variable "name" {
  default = "bastion"
}

variable "env" {
  type = string
}

variable "enable_bastion" {
  type    = bool
  default = true
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  default = "t3.micro"
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}
