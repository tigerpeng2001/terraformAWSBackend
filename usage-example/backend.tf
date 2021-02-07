terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-states-123456789012-us-east-2"

    # use different key to isolate the resource group
    key    = "example/terraform.tfstate"

    # you may perfer to use environment var for credential
    # such as export AWS_PROFILE=default
    #profile = "default"

    # variable not allowed for backend
    # region  = var.region
    region  = "us-east-2"


    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
