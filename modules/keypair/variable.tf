variable "key_name" {
  description = "Name of the key pair"
  type        = string
}

variable "public_key" {
  description = "Public key content (optional)"
  type        = string
  default     = ""
}

variable "public_key_path" {
  description = "Path to public key file (optional)"
  type        = string
  default     = ""
}