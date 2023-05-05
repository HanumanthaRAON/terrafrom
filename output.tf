output "vpcid" {
  value = module.access.vpc
}

output "aws_pub" {
  value = module.access.pubs
}



# output "mysqlp" {
#   value     = module.RDS_mysql.mysql_admin_pass
#   sensitive = true
# }

# output "eks-dev-role" {
#     value = module.EKS.eks-dev-role

# }