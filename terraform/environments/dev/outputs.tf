output "network_name" {
  value       = google_compute_network.custom_vpc.name
  description = "The name of the VPC"
}

output "network_id" {
  value       = google_compute_network.custom_vpc.id
  description = "The URI ID of the VPC"
}

output "subnet_name" {
  value       = google_compute_subnetwork.app_subnet.name
  description = "The name of the primary subnet"
}

output "subnet_id" {
  value       = google_compute_subnetwork.app_subnet.id
  description = "The URI ID of the primary subnet"
}

output "artifact_registry_repository" {
  value       = google_artifact_registry_repository.erp_repo.id
  description = "Full identifier of the Artifact Registry repository"
}

output "docker_registry_endpoint" {
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
  description = "Docker push/pull endpoint URL for CI/CD pipelines"
}