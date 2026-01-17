output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "ecs_cluster_name" {
  description = "ECS Cluster name"
  value       = aws_ecs_cluster.main.name
}

output "ecr_backend_repository_url" {
  description = "Backend ECR repository URL"
  value       = aws_ecr_repository.backend.repository_url
}

output "ecr_frontend_repository_url" {
  description = "Frontend ECR repository URL"
  value       = aws_ecr_repository.frontend.repository_url
}

output "frontend_url" {
  description = "Frontend application URL"
  value       = "http://${aws_lb.frontend.dns_name}"
}

output "backend_service_discovery_name" {
  description = "Backend service discovery endpoint"
  value       = "backend.${aws_service_discovery_private_dns_namespace.main.name}"
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.frontend.dns_name
}