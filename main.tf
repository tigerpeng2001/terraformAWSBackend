provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

module "data" {
  source = "./data"
}

resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
    local.common_fix_tags,
    local.common_var_tags,
    map(
      "Name", "Terraform Lock Table"
    )
  )
}

resource "aws_s3_bucket" "tfstate" {
  bucket        = "terraform-states-${module.data.account_id}"
  acl           = "private"
  force_destroy = "false"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    noncurrent_version_expiration {
      days = 30
    }
  }

  tags = merge(
    local.common_fix_tags,
    local.common_var_tags,
    map(
      "Name", "tfstate bucket"
    )
  )
}

resource "aws_s3_bucket_public_access_block" "tfstat-no-public-access" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}


output "tfstat_bucket_name" {
  value = "${aws_s3_bucket.tfstate.bucket}"
}
