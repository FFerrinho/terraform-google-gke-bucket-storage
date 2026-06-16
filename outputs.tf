output "k8s_service_account_name" {
  description = "Name of the Kubernetes Service Account created or used."
  value       = var.k8s_service_account_name
}

output "k8s_storage_class" {
  description = "Name of the StorageClass created for GCS Fuse CSI."
  value       = var.k8s_storage_class
}

output "k8s_persistent_volume_name" {
  description = "Name of the PersistentVolume created for the GCS bucket (null if not created)."
  value       = var.k8s_persistent_volume_name
}

output "k8s_pv_claim_name" {
  description = "Name of the PersistentVolumeClaim created for the GCS bucket (null if not created)."
  value       = var.k8s_pv_claim_name
}

output "service_account_email" {
  description = "Email of the GCP Service Account used for Workload Identity."
  value       = var.service_account_email
}

output "bucket_name" {
  description = "Name of the GCS bucket used for storage."
  value       = var.bucket_name
}
