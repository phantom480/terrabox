module "vpc" {
    source = "./modules/vpc"
    cidr_block = "10.0.0.0/16"
    env = "prod"
    azs = ["ap-south-1a" , "ap-south-1b"]
    public_subnets = ["10.0.1.0/24" , "10.0.2.0/24"]
    private_subnets = ["10.0.3.0/24" , "10.0.4.0/24"]
}

#module for alb

module "alb" {
  source = "./modules/alb"

  name               = "my-alb"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnets
  security_group_ids = [module.web_sg.security_group_id]

  tags = {
    Project = "portfolio"
  }
}
# security group 

# Root main.tf

module "web_sg" {
  source = "./modules/security"

  sg_name = "web-sg"
  vpc_id  =  module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}


module "ec2" {
  source = "./modules/ec2"

  name         = "app-server"
  env          = "dev"
  ami_id       = "ami-05d2d839d4f73aafb"
  instance_type = "t3.micro"

  subnet_id = module.vpc.public_subnets[0]

  security_group_ids = [module.web_sg.security_group_id]

  key_name = "my-key"

  associate_public_ip = true

  # ALB integration
  attach_to_alb     = true
  target_group_arn  = module.alb.target_group_arn
}

#module for rds

module "rds" {
  source = "./modules/rds"

  db_name  = "myapp"
  username = "phantom480"
  password = "Aarif$123"

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id

  allowed_security_groups = [module.web_sg.security_group_id]
}

#key pair

module "keypair" {
  source = "./modules/keypair"

  key_name   = "my-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMuYrmZyzllfIJQ3SCm5Hou9z4Vym2PfgdKA0n3Tksr5"
}



module "s3_bucket" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
  environment = var.environment
}
variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "bucket_name" {
  type        = string
  description = "Unique S3 bucket name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

output "bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "bucket_arn" {
  value = module.s3_bucket.bucket_arn
}