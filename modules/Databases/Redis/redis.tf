## Reading the SUBNET details 

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc]
  }
 tags = {
   "Name" = "Private Subnet*"
 }
}


resource "aws_elasticache_cluster" "example" {
  cluster_id           = var.cluster_id
  engine               = var.engine
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = "default.redis3.2"
  engine_version       = "6.2"
  port                 = var.port
  subnet_group_name = aws_elasticache_subnet_group.lamp_dev_redis_sub
  tags = {
    Name = "Dev-redis"
  }
}



### Create RDS Secuirty Group to allow connections
resource "aws_security_group" "lamp_dev_redis_sg" {
  name_prefix = "lamp_dev_redis_sg"
  vpc_id = var.vpc

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


### Create RDS DB Subnet group
resource "aws_elasticache_subnet_group" "lamp_dev_redis_sub" {
  name       = "lamp_dev-redis-subnet-group"
  subnet_ids = data.aws_subnets.private.ids
}