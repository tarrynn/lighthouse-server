module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.19"
  subnets         = module.vpc.public_subnets
  write_kubeconfig = false

  tags = {
    Environment = "test"
  }

  vpc_id = module.vpc.vpc_id
  enable_irsa = true

  workers_group_defaults = {
    root_volume_type = "gp2"
    root_volume_size = "100"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      tags                          = [
                                        {
                                          key = "k8s.io/cluster-autoscaler/${local.cluster_name}"
                                          value = "owned"
                                          propagate_at_launch = true
                                        },
                                        {
                                          key = "k8s.io/cluster-autoscaler/enabled"
                                          value = true
                                          propagate_at_launch = true
                                        }
                                      ]
      instance_type                 = "t2.medium"
      health_check_type             = "EC2"
      public_ip                     = true
      subnets                       = module.vpc.public_subnets
      asg_desired_capacity          = 2
      asg_min_size                  = 2
      asg_max_size                  = 5
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      bootstrap_extra_args          = "--enable-docker-bridge true"
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
