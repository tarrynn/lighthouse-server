variable "access_key" {}
variable "secret_key" {}
variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-1"
}

variable "vpc_id" {
  description = "Default VPC id"
  default     = "vpc-6b7d460f"
}

variable "subnet_ids" {
  description = "Default subnet ids"
  default     = ["subnet-b6dad8c0","subnet-6fddd10b","subnet-80054dd8"]
}

# the ami used for the launch config
variable "aws_ami" {
  description = "The AWS AMI id for production"
  default     = "ami-096f43ef67d75e998"
}

variable "availability_zones" {
  default     = "eu-west-1b,eu-west-1c,eu-west-1a"
  description = "List of availability zones, use AWS CLI to find your "
}

variable "key_name" {
  description = "Name of AWS key pair"
  default = "instance"
}

variable "instance_type" {
  default     = "m4.medium"
  description = "AWS instance type"
}

variable "node_min" {
  description = "Min numbers of nodes in EKS"
  default     = "2"
}

variable "node_max" {
  description = "Max numbers of nodes in EKS"
  default     = "5"
}

variable "node_desired" {
  description = "Desired numbers of nodes in EKS"
  default     = "2"
}

variable "sec_group" {
  description = "default security group"
  default = "sg-02b8b664"
}

variable "instance_profile" {
  description = "EKS-nodes IAM role"
  default = "EKS-nodes"
}
