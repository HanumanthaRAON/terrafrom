variable "vpc" {
  description = "AWS VPC "
}

variable "cluster_id" {
  description = "REDIS CLUSTER NAME"
  type = string
}

variable "engine" {
  description = "REDIS ENGINE VERSION"
  type = string
}

variable "node_type" {
  description = "NODE CONFIG"
  type = string
}

variable "num_cache_nodes" {
  description = "NUMBER REDIS INSTANCES"
  type = string
}

variable "port" {
 descdescription = "REDIS PORT" 
 type = string
}