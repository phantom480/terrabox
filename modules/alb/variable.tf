variable "name" {
  description = "ALB name"
  type        = string
}

variable "internal" {
  description = "Internal or internet-facing"
  type        = bool
  default     = false
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "listener_port" {
  default = 80
}

variable "target_port" {
  default = 80
}

variable "health_check_path" {
  default = "/"
}

variable "enable_deletion_protection" {
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}