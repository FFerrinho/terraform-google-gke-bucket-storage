# Complete example creating a new K8s Service Account and binding it to GCP SA
module "gcs_bucket_storage" {
  source = "../.."

  project_id              = "my-project-id"
  gke_cluster_name       = "my-gke-cluster"
  gke_service_account_email = "gke-sa@my-project-id.iam.gserviceaccount.com"
  bucket_name            = "my-existing-bucket"

  # Kubernetes configuration
  k8s_namespace          = "my-namespace"
  k8s_service_account_name = "gcs-fuse-sa"
  create_k8s_service_account = true

  # Storage configuration
  k8s_storage_class      = "gcs-fuse-csi"
  k8s_persistent_volume_name = "gcs-fuse-pv"
  k8s_pv_claim_name     = "gcs-fuse-pvc"

  # Optional configurations
  k8s_pv_capacity       = "200Gi"
  k8s_pv_read_only     = false
  k8s_pv_mount_options = [
    "implicit-dirs",
    "uid=33",
    "gid=33"
  ]
}
