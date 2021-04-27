provider "aws" {
  region = "ap-southeast-1"
}

locals {
  clusterName = "terraform-app-stage"
}

module "vpc" {
  source              = "../../modules/vpc"
  cluster_name        = local.clusterName
  vpc_cidr_block      = "100.0.0.0/16"
  subnet_a_cidr_block = "100.0.0.0/20"
  subnet_b_cidr_block = "100.0.16.0/20"
  subnet_c_cidr_block = "100.0.32.0/20"
}

# module "autoscaling" {
#   source        = "../../../modules/services/autoscaling"
#   cluster_name  = local.clusterName
#   image_ami     = "ami-03ca998611da0fe12"
#   instance_type = "t2.micro"
#   min_size      = 2
#   max_size      = 2
# }