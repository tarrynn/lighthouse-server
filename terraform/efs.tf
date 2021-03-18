resource "aws_efs_file_system" "efs_volume" {
  creation_token = module.eks.cluster_id
  encrypted = true

  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }
}

resource "aws_efs_mount_target" "efs_mt" {
  for_each = toset(module.vpc.private_subnets)
  file_system_id = aws_efs_file_system.efs_volume.id
  security_groups = [aws_security_group.worker_group_mgmt_one.id]
  subnet_id      = each.value
}
