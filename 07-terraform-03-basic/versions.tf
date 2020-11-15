terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

//
//#s3_bucket для хранения backend s3
//resource "aws_s3_bucket" "kaa-terraform-states" {
//bucket = "kaa-terraform-states"
//acl = "private"
//
//tags = {
//    Name = "Terraform-states"
//    Environment = "Test"
//  }
//}


terraform {
  backend "s3" {
    bucket = "kaa-terraform-states"
    key = "main-infra/terraform.tfstate"
    region = "eu-west-3"
  }
}


