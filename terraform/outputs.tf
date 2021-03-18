output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "oidc_url" {
  description = "OIDC URL"
  value       = module.eks.cluster_oidc_issuer_url
}

output "efs_id" {
  description = "EFS ID"
  value       = aws_efs_file_system.efs_volume.id
}
