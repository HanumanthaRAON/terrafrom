terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.57.0"
    }
  }

  # backend "s3" {
  #   bucket = ""
  #   key = "value"
  #   region = "us-east-1"
  # }
}

provider "random" {

}

provider "aws" {
  # Configuration options
  access_key = ""
  secret_key = ""
  region     = var.aws-region
}
