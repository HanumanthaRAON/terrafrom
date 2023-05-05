#########################  VPC Variables #################################
variable "aws-region" {
  description = "default region"
  type        = string
  default     = "us-east-1"
}

variable "dev_vpc_cidr" {
  description = "vpc cidr range for subnet"
  type        = string
  default     = "172.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "public subnet range"
  default     = ["172.20.1.0/24", "172.20.2.0/24", "172.20.3.0/24"]
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "private subnet range"
  type        = list(string)
  default     = ["172.20.4.0/24", "172.20.5.0/24", "172.20.6.0/24"]
}

variable "az_count" {
  description = "Availabity zones"
  default     = 3
}
#########################  VPC Variables #################################

#########################  RDS(MYSQL) Variables ##########################
variable "db_name" {
  default = "devdb"
}
variable "db_user_name" {
  default = "devuser"
}
variable "db_instance_type" {
  default = "db.t3.micro"
}
variable "db_storage" {
  type    = number
  default = 20
}
variable "db_storage_type" {
  type    = string
  default = "gp3"
}
variable "multi_az" {
  default = false
  type    = bool
}

variable "db_engine_version" {
  default = "8.0"
}