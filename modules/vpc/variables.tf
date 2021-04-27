variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "subnet_a_cidr_block" {
  type        = string
  description = "subnet CIDR block"
}

variable "subnet_b_cidr_block" {
  type        = string
  description = "subnet CIDR block"
}

variable "subnet_c_cidr_block" {
  type        = string
  description = "subnet CIDR block"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "cluster_name" {
  type        = string
  description = "cluster name"
}