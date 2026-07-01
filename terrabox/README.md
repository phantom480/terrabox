# terrabox

Terraform code for a 3-tier AWS setup — ALB in the front, app instances in an
autoscaling group behind it, RDS at the back. Built this to practice writing
proper modular Terraform instead of one giant main.tf, and to actually get
the network/security tiering right instead of throwing everything in one
public subnet.

## What it creates

- VPC with public + private subnets across 2 AZs, NAT gateway for the
  private subnets
- ALB in the public subnets, listens on 80
- Auto scaling group (app tier) in the private subnets, registered to the
  ALB target group
- RDS (MySQL) in the private subnets, only reachable from the app tier sg
- S3 bucket for app data, versioned + encrypted + blocked from public access
- IAM role for the app instances, scoped to just that one bucket
- Optional bastion host if you need to SSH into the private instances

Each of these is its own module under `modules/`.

## Why not just one ec2 instance like before

Had a single ec2 in a public subnet earlier which isn't really a 3-tier
setup, just one tier. Moved the app instances into private subnets behind
the ALB and swapped the single instance for an ASG so it can actually scale
and recover if an instance dies.

## Before you apply

Don't hardcode secrets in the .tf files. This project needs a db password
and it deliberately has no default, so terraform will complain if you don't
supply one:

```bash
export TF_VAR_db_password="something-strong"
```

or copy `terraform.tfvars.example` to `terraform.tfvars` and fill it in
(this file is gitignored, so it never gets pushed).

Also set `allowed_ssh_cidr` to your own IP, not `0.0.0.0/0`, if you're
using the bastion.

SSH key: if you don't pass a `public_key`, terraform generates one for you
and drops the private key in the repo root (also gitignored).

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Once it's up:

```bash
terraform output alb_dns_name
```

open that in a browser, should hit nginx running on one of the app
instances.

```bash
terraform destroy
```

when you're done, don't leave this running, RDS + NAT gateway are not free.

## Notes

- single NAT gateway to keep costs down, not one per AZ (that'd be the
  right call for prod, just not for a portfolio project)
- `skip_final_snapshot = true` by default on the RDS instance so destroy
  doesn't hang around waiting for a snapshot, flip it for anything real
