# terraform state file setup
# create an S3 bucket to store the state file in
# resource "aws_s3_bucket" "opsschool-dina-state-storage-s3" {
#     bucket = "opsschool-dina-remote-state-storage-s3"
#     provider = "aws"
#     versioning {
#       enabled = true
#     }
 
#     # lifecycle {
#     #   prevent_destroy = true
#     # }
 
#     # tags {
#     #   Name = "S3 Remote Terraform State Store"
#     # }
# }
# #create a dynamodb table for locking the state file
# resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
#   name = "opsschool-dina-state-lock-dynamo"
#   hash_key = "LockID"
#   read_capacity = 20
#   write_capacity = 20

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   # tags {
#   #   Name = "DynamoDB Terraform State Lock Table"
#   # }
# }

terraform {
backend "s3" {
   bucket = "opsschool-dina-state-storage-s3"
   key    = "terraform/state"
   encrypt = true
   region = "us-east-1"
  }
}
