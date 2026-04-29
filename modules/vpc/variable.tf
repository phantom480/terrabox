variable "cidr_block" {
    description = "this is the cidr_block variable"
    type  =  string
  
}
variable "env" {
    description = "this is the cidr_block variable"
    type  =  string
  
}
variable "public_subnets" {
    description = "this is the public_subnets variable"
    type  =  list(string)
  
}
variable "private_subnets" {
    description = "this is the private_subnets variable"
    type  = list(string)
  
}
variable "azs" {
    description = "this is the avialability variable"
    type  = list(string)
  
}

