data "google_project" "main" {
  project_id = var.project_id
}

# Create the Kubernetes Service Account for GCS Fuse CSI
resource "kubernetes_service_account_v1" "main" {
  provider = kubernetes
  metadata {
    name      = var.k8s_service_account
    namespace = var.k8s_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = var.gke_service_account
    }
  }
}

# Bind the Kubernetes Service Account to the Google Cloud Service Account
resource "google_service_account_iam_binding" "gcs-fuse-csi-sa" {
  service_account_id = "${data.google_project.main.id}/serviceAccounts/${var.gke_service_account}"
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${data.google_project.main.project_id}.svc.id.goog[${kubernetes_service_account_v1.main.id}]"]
}

# Define the members for the storage bucket
locals {
  storage_bucket_members = [
    "serviceAccount:${var.gke_service_account}",
    "principal://iam.googleapis.com/projects/${data.google_project.main.number}/locations/global/workloadIdentityPools/${data.google_project.main.project_id}.svc.id.goog/subject/ns/bsp/sa/${kubernetes_service_account_v1.main.metadata[0].name}"
  ]
}

# Grant access to the storage bucket
resource "google_storage_bucket_iam_member" "main" {
  for_each = toset(local.storage_bucket_members)
  bucket   = module.gke_bsp_storage.name
  role     = "roles/storage.objectAdmin"
  member   = each.key
}

# Create the Storage Class for GCS Fuse CSI
resource "kubernetes_storage_class_v1" "main" {
  provider = kubernetes
  metadata {
    name = var.k8s_storage_class
  }
  storage_provisioner    = "gcsfuse.csi.storage.gke.io"
  allow_volume_expansion = var.k8s_storage_class_allow_storage_expansion
}

# Create the Persistent Volume for GCS Fuse CSI
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

  depends_on = [google_storage_bucket_iam_member.main]
}

# Create the Persistent Volume Claim for GCS Fuse CSI
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

  depends_on = [
    kubernetes_persistent_volume.main
  ]
}
