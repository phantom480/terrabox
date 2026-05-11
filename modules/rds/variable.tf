variable "db_name" {}
variable "username" {}
variable "password" {
  sensitive = true
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "allocated_storage" {
  default = 20
}

variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "8.0"
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {}

variable "allowed_security_groups" {
  type = list(string)
}