# terraform state file setup
# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform-state-storage-s3" {
    bucket = "terraform-remote-state-storage-s3"
    provider = "aws"
    versioning {
      enabled = true
    }
 
    lifecycle {
      prevent_destroy = true
    }
 
    # tags {
    #   Name = "S3 Remote Terraform State Store"
    # }
}

# terraform {
# backend "s3" {
#    bucket = "terraform-remote-state-storage-s3"
#    key    = "terraform/state"
#    encrypt = true
#    region = "us-east-1"
#   }
# }
