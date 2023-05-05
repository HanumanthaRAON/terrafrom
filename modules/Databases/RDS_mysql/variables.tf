variable "db_name"{
    default = "devdb"
}
variable "db_user_name"{
    default = "devuser"
}
variable "db_instance_type"{
    default = "db.t3.micro"
}
variable "db_storage"{
    type = number
    default = 20
}
variable "db_storage_type" {
    type = string
    default = "gp3"
}
variable "multi_az" {
  default = false
  type = bool
}
variable "vpc" {
  
}

variable "db_engine_version" {
    description = "Mysql DB version"
    
}

