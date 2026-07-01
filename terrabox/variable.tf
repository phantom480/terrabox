variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "terrabox"
}

variable "environment" {
  type    = string
  default = "dev"
}

# networking

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

# access

variable "key_name" {
  type    = string
  default = "terrabox-key"
}

variable "public_key" {
  description = "leave blank to auto generate a key pair"
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr" {
  description = "your IP only, dont leave this open to 0.0.0.0/0"
  type        = list(string)
}

variable "enable_bastion" {
  type    = bool
  default = true
}

# app tier

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 3
}

variable "asg_desired_capacity" {
  type    = number
  default = 2
}

# db tier

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type      = string
  default   = "dbadmin"
  sensitive = true
}

variable "db_password" {
  description = "no default on purpose, pass via TF_VAR_db_password or terraform.tfvars"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_multi_az" {
  type    = bool
  default = false
}

# s3

variable "bucket_name_prefix" {
  type    = string
  default = "terrabox-app-data"
}
