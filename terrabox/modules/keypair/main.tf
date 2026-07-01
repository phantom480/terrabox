# auto generates a key pair per deployment so i don't have to commit my own public key
resource "tls_private_key" "this" {
  count     = var.public_key == "" ? 1 : 0
  algorithm = "ED25519"
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = var.public_key != "" ? var.public_key : tls_private_key.this[0].public_key_openssh

  tags = {
    Name = var.key_name
  }
}

# saves the private key locally, gitignored, never commit this
resource "local_sensitive_file" "private_key" {
  count           = var.public_key == "" ? 1 : 0
  content         = tls_private_key.this[0].private_key_openssh
  filename        = var.private_key_output_path
  file_permission = "0600"
}
