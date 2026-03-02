terraform {
  backend "s3" {
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}