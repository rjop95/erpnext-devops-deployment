terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. Repositorio de Contenedores (Artifact Registry)
resource "google_artifact_registry_repository" "erp_repo" {
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker repository for ERPNext application images"
  format        = "DOCKER"
}

# 2. Red Privada Virtual (VPC)
resource "google_compute_network" "custom_vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# 3. Subred con rangos secundarios (optimizada para microservicios / GKE)
resource "google_compute_subnetwork" "app_subnet" {
  name                     = var.subnet_name
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.custom_vpc.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods-ip-range"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services-ip-range"
    ip_cidr_range = var.services_cidr
  }
}

# 4. Regla de Firewall para comunicación interna
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.network_name}-allow-internal"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = [
    var.subnet_cidr,
    var.pods_cidr
  ]
}

# 5. Regla de Firewall para tráfico web entrante
resource "google_compute_firewall" "allow_web" {
  name    = "${var.network_name}-allow-web"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["erp-web-entrypoint"]
}

# 6. Regla de Firewall para administración segura vía Identity-Aware Proxy (IAP)
resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "${var.network_name}-allow-iap-ssh"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Rango oficial de Google Cloud IAP
  source_ranges = ["35.235.240.0/20"]
}