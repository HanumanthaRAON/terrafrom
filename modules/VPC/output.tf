output "vpc_id" {
  value = aws_vpc.dev_vpc.id
}

output "eip" {
  value = aws_eip.dev_eip.address  
}