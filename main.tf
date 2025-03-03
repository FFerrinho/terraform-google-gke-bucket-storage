# Get the project information needed for various resource configurations
data "google_project" "main" {
  project_id = var.project_id
}

# Create a Kubernetes Service Account for GCS Fuse CSI if requested
# This is optional as the module can work with pre-existing service accounts
# The service account is annotated to work with GCP Workload Identity
resource "kubernetes_service_account_v1" "main" {
  count    = var.create_k8s_service_account ? 1 : 0
  provider = kubernetes
  metadata {
    name      = var.k8s_service_account_name
    namespace = var.k8s_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = var.gke_service_account_email
    }
  }
}

# Configure Workload Identity by binding the Kubernetes ServiceAccount to the GCP ServiceAccount
# This binding allows the K8s SA to impersonate the GCP SA using Workload Identity
resource "google_service_account_iam_binding" "gcs-fuse-csi-sa" {
  count              = var.create_k8s_service_account ? 1 : 0
  service_account_id = "${data.google_project.main.id}/serviceAccounts/${var.gke_service_account_email}"
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${data.google_project.main.project_id}.svc.id.goog[${var.k8s_namespace}/${var.k8s_service_account_name}]"]
}

# Configure the members that need access to the GCS bucket
# When creating a new K8s SA, both the GCP SA and Workload Identity pool need access
# When using existing SA, only the GCP SA needs access
locals {
  storage_bucket_members = var.create_k8s_service_account ? [
    "serviceAccount:${var.gke_service_account_email}",
    "principal://iam.googleapis.com/projects/${data.google_project.main.number}/locations/global/workloadIdentityPools/${data.google_project.main.project_id}.svc.id.goog/subject/ns/${var.k8s_namespace}/sa/${var.k8s_service_account_name}"
  ] : [
    "serviceAccount:${var.gke_service_account_email}"
  ]
}

# Grant storage.objectAdmin permissions to the configured members
# This allows both read and write access to objects in the bucket
resource "google_storage_bucket_iam_member" "main" {
  for_each = toset(local.storage_bucket_members)
  bucket   = var.bucket_name
  role     = "roles/storage.objectAdmin"
  member   = each.key

  depends_on = [
    kubernetes_service_account_v1.main
  ]
}

# Create a Kubernetes StorageClass for GCS Fuse CSI driver
# This defines how PersistentVolumes will be dynamically provisioned
resource "kubernetes_storage_class_v1" "main" {
  provider = kubernetes
  metadata {
    name = var.k8s_storage_class
  }
  storage_provisioner    = "gcsfuse.csi.storage.gke.io"
  allow_volume_expansion = var.k8s_storage_class_allow_storage_expansion
}

# Create a PersistentVolume that uses the GCS Fuse CSI driver
# This PV will be statically provisioned and bound to a specific GCS bucket
resource "kubernetes_persistent_volume" "main" {
  provider = kubernetes
  metadata {
    name = var.k8s_persistent_volume_name
  }

  spec {
    access_modes = var.k8s_pv_access_modes
    capacity = {
      storage = var.k8s_pv_capacity
    }
    storage_class_name = kubernetes_storage_class_v1.main.metadata[0].name

    persistent_volume_source {
      csi {
        driver        = "gcsfuse.csi.storage.gke.io"
        volume_handle = var.gke_cluster_name
        read_only     = var.k8s_pv_read_only
      }
    }

    claim_ref {
      name      = var.k8s_pv_claim_name
      namespace = var.k8s_namespace
    }

    mount_options = var.k8s_pv_mount_options
  }

  # Ensure IAM permissions are set before creating the PV
  depends_on = [google_storage_bucket_iam_member.main]
}

# Create a PersistentVolumeClaim that will be bound to the PV
# This PVC can be referenced by pods to mount the GCS bucket
resource "kubernetes_persistent_volume_claim_v1" "main" {
  metadata {
    name      = var.k8s_pv_claim_name
    namespace = var.k8s_namespace
  }

  spec {
    access_modes = var.k8s_pv_access_modes
    resources {
      requests = {
        storage = var.k8s_pv_capacity
      }
    }
    storage_class_name = kubernetes_storage_class_v1.main.metadata[0].name
    volume_name        = kubernetes_persistent_volume.main.id
  }

  # Ensure PV exists before creating PVC
  depends_on = [
    kubernetes_persistent_volume.main
  ]
}
