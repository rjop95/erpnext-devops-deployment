variable "project_id" {
  type        = string
  description = "The GCP Project ID where resources will be deployed"
}

variable "region" {
  type        = string
  description = "Google Cloud region for regional resources"
  default     = "us-central1"
}

variable "network_name" {
  type        = string
  description = "Name of the custom VPC network"
  default     = "erp-custom-vpc"
}

variable "subnet_name" {
  type        = string
  description = "Name of the main subnet"
  default     = "erp-app-subnet"
}

variable "subnet_cidr" {
  type        = string
  description = "Primary CIDR block for node instances and database"
  default     = "10.10.1.0/24"
}

variable "pods_cidr" {
  type        = string
  description = "Secondary CIDR block for container pods"
  default     = "10.20.0.0/16"
}

variable "services_cidr" {
  type        = string
  description = "Secondary CIDR block for internal services"
  default     = "10.30.0.0/20"
}

variable "repository_id" {
  type        = string
  description = "Name identifier for the Artifact Registry Docker repository"
  default     = "erpnext-images"
}