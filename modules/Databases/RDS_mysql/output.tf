output "mysql_admin_pass" {
  value = random_password.password.result
  sensitive = false
}

output "priv_subs" {
  value = data.aws_subnets.private.ids
  
}