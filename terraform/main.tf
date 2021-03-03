provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
}

module "eks" {
  source          = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v14.0.0"
  cluster_name    = "bergatest"
  cluster_version = "1.19"
  vpc_id          = var.vpc_id
  subnets         = var.subnet_ids

  node_groups = {
    eks_nodes = {
      desired_capacity = var.node_desired
      max_capacity     = var.node_max
      min_capacity     = var.node_min

      instance_type    = var.instance_type
    }
  }

  manage_aws_auth = false
}
