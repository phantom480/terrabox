# grabbing latest amazon linux ami instead of hardcoding one, it keeps going stale otherwise
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  cidr_block         = var.vpc_cidr
  env                = var.environment
  azs                = var.azs
  public_subnets     = var.public_subnet_cidrs
  private_subnets    = var.private_subnet_cidrs
  enable_nat_gateway = var.enable_nat_gateway
}

# alb sg - only thing open to the internet
module "alb_sg" {
  source = "./modules/security"

  sg_name = "${var.project_name}-${var.environment}-alb-sg"
  vpc_id  = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# bastion sg - ssh from my ip only
module "bastion_sg" {
  source = "./modules/security"
  count  = var.enable_bastion ? 1 : 0

  sg_name = "${var.project_name}-${var.environment}-bastion-sg"
  vpc_id  = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidr
    }
  ]
}

# app tier sg - traffic only from the alb + bastion, nothing from the internet directly
module "app_sg" {
  source = "./modules/security"

  sg_name = "${var.project_name}-${var.environment}-app-sg"
  vpc_id  = module.vpc.vpc_id

  ingress_rules = concat(
    [
      {
        from_port                = 80
        to_port                  = 80
        protocol                 = "tcp"
        source_security_group_id = module.alb_sg.security_group_id
      }
    ],
    var.enable_bastion ? [
      {
        from_port                = 22
        to_port                  = 22
        protocol                 = "tcp"
        source_security_group_id = module.bastion_sg[0].security_group_id
      }
    ] : []
  )
}

module "keypair" {
  source = "./modules/keypair"

  key_name   = var.key_name
  public_key = var.public_key
}

module "s3_bucket" {
  source = "./modules/s3"

  bucket_name_prefix = var.bucket_name_prefix
  environment         = var.environment
}

# instance role for app tier, scoped to just the bucket above
module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  env          = var.environment
  bucket_arn   = module.s3_bucket.bucket_arn
}

module "alb" {
  source = "./modules/alb"

  name               = "${var.project_name}-${var.environment}-alb"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnets
  security_group_ids = [module.alb_sg.security_group_id]

  tags = {
    Project = var.project_name
  }
}

# app tier - asg instead of a single ec2, so it can actually scale + self heal
module "app_tier" {
  source = "./modules/asg"

  name              = "${var.project_name}-${var.environment}-app"
  env               = var.environment
  ami_id            = data.aws_ami.amazon_linux.id
  root_device_name = data.aws_ami.amazon_linux.root_device_name
  instance_type     = var.instance_type

  subnet_ids          = module.vpc.private_subnets
  security_group_ids = [module.app_sg.security_group_id]

  key_name              = module.keypair.key_name
  iam_instance_profile = module.iam.instance_profile_name

  target_group_arn = module.alb.target_group_arn
  user_data_base64 = base64encode(file("${path.module}/scripts/app_user_data.sh"))

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity

  tags = {
    Project = var.project_name
  }
}

# jump box to reach the private instances over ssh, optional
module "bastion" {
  source = "./modules/bastion"

  name           = "${var.project_name}-bastion"
  env            = var.environment
  enable_bastion = var.enable_bastion

  ami_id        = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = module.keypair.key_name

  security_group_ids = var.enable_bastion ? [module.bastion_sg[0].security_group_id] : []
}

module "rds" {
  source = "./modules/rds"

  identifier = "${var.project_name}-${var.environment}-db"
  db_name    = var.db_name
  username   = var.db_username
  password   = var.db_password

  instance_class = var.db_instance_class
  multi_az       = var.db_multi_az

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id

  allowed_security_groups = [module.app_sg.security_group_id]
}
