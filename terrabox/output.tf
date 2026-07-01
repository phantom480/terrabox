output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "app_asg_name" {
  value = module.app_tier.asg_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "s3_bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "ssh_private_key_path" {
  value = module.keypair.private_key_path
}
