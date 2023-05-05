## Reading the SUBNET details 

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc]
  }
 tags = {
   Name = "${terraform.workspace}-PrivateSubnet-*"
 }
}


### Generate random password for mysql DB
resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

### Launch AWS RDS Instance (Mysql)
resource "aws_db_instance" "lamp_dev_db" {
  identifier          = "${terraform.workspace}-mysql"
  engine              = "mysql"
  engine_version      = var.db_engine_version
  instance_class      = var.db_instance_type
  allocated_storage   = var.db_storage
  db_name             = var.db_name
  username            = var.db_user_name
  password            = random_password.password.result
  storage_type         = var.db_storage_type
  multi_az             = var.multi_az
  vpc_security_group_ids = [aws_security_group.lamp_dev_db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.lamp_dev_db_sub.id
  skip_final_snapshot = true
  deletion_protection = true


  tags = {
    Name = " ${terraform.workspace}-db-instance"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

### Create RDS Secuirty Group to allow connections
resource "aws_security_group" "lamp_dev_db_sg" {
  name_prefix = "${terraform.workspace}-db-sg"
  vpc_id = var.vpc

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### Create RDS DB Subnet group
resource "aws_db_subnet_group" "lamp_dev_db_sub" {
  name       = "${terraform.workspace}-db-subnet-group"
  subnet_ids = data.aws_subnets.private.ids
}
