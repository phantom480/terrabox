variable "name" {
  type = string
}

variable "env" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  default = "t2.micro"
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "associate_public_ip" {
  type    = bool
  default = false
}

variable "user_data" {
  type    = string
  default = ""
}

# ALB Integration
variable "attach_to_alb" {
  type    = bool
  default = false
}

variable "target_group_arn" {
  type    = string
  default = ""
}

variable "target_port" {
  default = 80
}

variable "tags" {
  type    = map(string)
  default = {}
}