
module "VPC" {
  source               = "./modules/VPC"
  dev_vpc_cidr        = var.dev_vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  az_count             = var.az_count
  aws-region           = var.aws-region
}




# module "RDS_mysql" {
#   source            = "./modules/Databases/RDS_mysql"
#   vpc               = module.VPC.vpc_id
#   db_name           = var.db_name
#   db_instance_type  = var.db_instance_type
#   db_storage        = var.db_storage
#   db_user_name      = var.db_user_name
#   db_engine_version = var.db_engine_version
# }

# module "EKS" {
#   source = "./modules/EKS"
#   vpc    = module.VPC.vpc_id

# }

module "access" {
  source = "./modules/access"
  vpc = module.VPC.vpc_id
  
}