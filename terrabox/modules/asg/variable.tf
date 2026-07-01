variable "name" {
  type = string
}

variable "env" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "root_device_name" {
  default = "/dev/xvda"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "iam_instance_profile" {
  default = ""
}

variable "subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  default = ""
}

variable "user_data_base64" {
  default = null
}

variable "root_volume_size" {
  default = 8
}

variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 3
}

variable "desired_capacity" {
  default = 2
}

variable "cpu_target_value" {
  default = 60
}

variable "tags" {
  type    = map(string)
  default = {}
}
