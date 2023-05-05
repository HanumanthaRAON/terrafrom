data "aws_subnets" "pub" {
  filter {
    name   = "tag:Name"
    values = [var.vpc]
  }
 tags = {
   Name = "dev-PublicSubnet*"
 }
}

output "vpc" {
  value = var.vpc
} 

output "pubs" {
  value = data.aws_subnets.pub.ids
}

# data "aws_key_pair" "bastion_key" {
#     key_name = "Bastion_key"
#     include_public_key = true
# }

# resource "aws_security_group" "bastion-sg" {
#     name = "bastion-sg"
#     vpc_id = var.vpc
#     ingress {
#     description      = "SSH from VPC"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = {
#     Name = "allow_ssh"
#   }
# }

# resource "aws_instance" "bastion_host" {
#   ami = "ami-06e46074ae430fba6"
#   instance_type = "t2.micro"
#   key_name = data.aws_key_pair.bastion_key.key_name
#   associate_public_ip_address = true
#   subnet_id = data.aws_subnets.public.ids
#   vpc_security_group_ids = [
#     aws_security_group.bastion-sg.id
#   ]
#   root_block_device {
#     delete_on_termination = true
#     iops = 150
#     volume_size = 20
#     volume_type = "gp3"
#   }
#   depends_on = [ aws_security_group.bastion-sg ]
# }

