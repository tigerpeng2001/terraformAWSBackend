provider "aws" {}

module "data" {
  source = "data"
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

  tags = "${merge(
    local.common_fix_tags,
    local.common_var_tags,
    map (
    "Name", "Terraform Lock Table"
    )
  )}"
}

resource "aws_s3_bucket" "tfstate" {
  bucket        = "terraform-states-${module.data.account_id}-${module.data.region}"
  acl           = "private"
  force_destroy = "false"

  lifecycle_rule {
    enabled = true

    noncurrent_version_expiration {
      days = 30
    }
  }

  tags = "${merge(
    local.common_fix_tags,
    local.common_var_tags,
    map (
    "Name", "tfstate bucket"
    )
  )}"
}

output "tfstat_bucket_name" {
  value = "${aws_s3_bucket.tfstate.bucket}"
}
