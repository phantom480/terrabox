data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app_role" {
  name               = "${var.project_name}-${var.env}-app-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name = "${var.project_name}-${var.env}-app-role"
  }
}

# scoped to just this bucket instead of using a broad managed policy like AmazonS3FullAccess
data "aws_iam_policy_document" "s3_access" {
  statement {
    sid = "ListBucket"
    actions = [
      "s3:ListBucket",
    ]
    resources = [var.bucket_arn]
  }

  statement {
    sid = "ReadWriteObjects"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["${var.bucket_arn}/*"]
  }
}

resource "aws_iam_role_policy" "s3_access" {
  name   = "${var.project_name}-${var.env}-app-s3-access"
  role   = aws_iam_role.app_role.id
  policy = data.aws_iam_policy_document.s3_access.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.project_name}-${var.env}-app-profile"
  role = aws_iam_role.app_role.name
}
