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
  access_key = "AKIAQMNNK4K7YGJAXYYJ"
  secret_key = "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"
  region     = var.aws-region
}
