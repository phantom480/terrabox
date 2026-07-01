variable "identifier" {
  type = string
}

variable "db_name" {
  type = string
}

variable "username" {
  type      = string
  sensitive = true
}

variable "password" {
  description = "no hardcoded default, pass it in via tfvars/env var"
  type        = string
  sensitive   = true
}

variable "db_port" {
  default = 3306
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

variable "vpc_id" {
  type = string
}

variable "allowed_security_groups" {
  type = list(string)
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "backup_retention_period" {
  default = 7
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "deletion_protection" {
  type    = bool
  default = false
}
