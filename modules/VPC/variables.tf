variable "dev_vpc_cidr" {
  description = "vpc cidr range for subnet"
  type        = string
  default     = "172.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "public subnet range"
  default     = ["172.20.1.0/24", "172.20.2.0/24" , "172.20.3.0/24"]
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "private subnet range"
  type        = list(string)
  default     = ["172.20.4.0/24", "172.20.5.0/24" , "172.20.6.0/24"]
}

variable "az_count" {
  description = "Availabity zones"
  default     = 3
}

variable "aws-region" {
    description =   "AWS Region"
    default = "us-east-1"
}



