# terraformAWSBackend
## Purpose:
Create AWS S3 backend with DynamoDB table for locking. S3 objects are private, encrypted,  versioning enabled with default version retention 180 days. 
## Usage:
### Create S3 backend;
```sh
$ terraform plan -out plan.out
var.profile
  Enter a value: terraform-user 

var.region
  Enter a value: us-east-1
```
### Example:
include a .tf file in your main module as below
```hcl
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-states-123456789012-us-east-1"

    # use different key to isolate the resource group
    key    = "example/terraform.tfstate"

    # you may prefer to use environment var for credential
    # such as export AWS_PROFILE=default
    profile = "default"

    # variable not allowed for backend
    # region  = var.region
    region  = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```
## License
Copyright (c) 2001, Tiger Peng
All rights reserved.

Distributed under the MIT License. See `LICENSE` for more information.
## Contact

Tiger Peng tigerpeng2001@yahoo.com