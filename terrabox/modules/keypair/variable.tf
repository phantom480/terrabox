variable "key_name" {
  type = string
}

variable "public_key" {
  description = "leave empty to auto generate a key pair"
  type        = string
  default     = ""
}

variable "private_key_output_path" {
  type    = string
  default = "./generated-key.pem"
}
