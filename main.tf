<<<<<<< HEAD
variable "region" {
  default = "us-east-1"
}
variable "profile" {
  default = "default"
}

variable "retention-days" {
  default = 180
}
provider "aws" {
  region  = var.region
  profile = var.profile
=======
provider "aws" {
  region  = "us-east-1"
  profile = "default"
>>>>>>> 0425ba37303f69379a22e29de99f01f8d03e6593
}

module "data" {
  source = "./data"
}

resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  lifecycle {
    prevent_destroy = true
  }

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

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = var.retention-days
    }
  }

<<<<<<< HEAD
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
=======
>>>>>>> 0425ba37303f69379a22e29de99f01f8d03e6593
  tags = merge(
    local.common_fix_tags,
    local.common_var_tags,
    map(
      "Name", "tfstate bucket"
    )
  )
<<<<<<< HEAD
}

resource "aws_s3_bucket_public_access_block" "no-public-access-tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
=======
>>>>>>> 0425ba37303f69379a22e29de99f01f8d03e6593
}

resource "aws_s3_bucket_public_access_block" "tfstat-no-public-access" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}


output "tfstat_bucket_name" {
  value = aws_s3_bucket.tfstate.bucket
}
