# Example using existing Service Accounts (Workload Identity already configured)
module "gcs_bucket_storage" {
  source = "../.."

  project_id              = "my-project-id"
  gke_cluster_name       = "my-gke-cluster"
  gke_service_account_email = "gke-sa@my-project-id.iam.gserviceaccount.com"
  bucket_name            = "my-existing-bucket"

  # Kubernetes configuration with existing SA
  k8s_namespace          = "my-namespace"
  k8s_service_account_name = "existing-gcs-sa"
  create_k8s_service_account = false  # Don't create new SA or IAM binding

  # Storage configuration
  k8s_storage_class      = "gcs-fuse-csi"
  k8s_persistent_volume_name = "gcs-fuse-pv"
  k8s_pv_claim_name     = "gcs-fuse-pvc"

  # Using default mount options and capacity
}
