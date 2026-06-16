data "google_project" "main" {
  project_id = var.project_id
}

resource "kubernetes_service_account_v1" "main" {
  count    = var.create_k8s_service_account ? 1 : 0
  provider = kubernetes
  metadata {
    name      = var.k8s_service_account_name
    namespace = var.k8s_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = var.service_account_email
    }
    labels = {
      managed_by = "terraform"
    }
  }
}

resource "google_service_account_iam_member" "gcs-fuse-csi-sa" {
  count              = var.create_k8s_service_account ? 1 : 0
  service_account_id = "${data.google_project.main.id}/serviceAccounts/${var.service_account_email}"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${data.google_project.main.project_id}.svc.id.goog[${var.k8s_namespace}/${var.k8s_service_account_name}]"
}

locals {
  storage_bucket_members = var.create_k8s_service_account ? [
    "serviceAccount:${var.service_account_email}",
    "principal://iam.googleapis.com/projects/${data.google_project.main.number}/locations/global/workloadIdentityPools/${data.google_project.main.project_id}.svc.id.goog/subject/ns/${var.k8s_namespace}/sa/${var.k8s_service_account_name}"
  ] : [
    "serviceAccount:${var.service_account_email}"
  ]
}

resource "google_storage_bucket_iam_member" "object_admin" {
  for_each = toset(local.storage_bucket_members)
  bucket   = var.bucket_name
  role     = "roles/storage.objectAdmin"
  member   = each.key

  depends_on = [kubernetes_service_account_v1.main]
}

resource "google_storage_bucket_iam_member" "bucket_viewer" {
  for_each = toset(local.storage_bucket_members)
  bucket   = var.bucket_name
  role     = "roles/storage.bucketViewer"
  member   = each.key

  depends_on = [kubernetes_service_account_v1.main]
}

resource "kubernetes_storage_class_v1" "main" {
  metadata {
    name = var.k8s_storage_class
    labels = {
      managed_by = "terraform"
    }
  }
  storage_provisioner    = "gcsfuse.csi.storage.gke.io"
  allow_volume_expansion = var.k8s_storage_class_allow_storage_expansion
}

resource "kubernetes_persistent_volume_v1" "main" {
  count = var.k8s_persistent_volume_name != null ? 1 : 0
  metadata {
    name = var.k8s_persistent_volume_name
    labels = {
      managed_by = "terraform"
    }
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
        volume_handle = var.bucket_name
        read_only     = var.k8s_pv_read_only
      }
    }

    dynamic "claim_ref" {
      for_each = var.k8s_pv_claim_name != null ? [var.k8s_pv_claim_name] : []
      content {
        name      = var.k8s_pv_claim_name
        namespace = var.k8s_namespace
      }
    }

    mount_options = var.k8s_pv_mount_options
  }

  depends_on = [
    google_storage_bucket_iam_member.object_admin,
    google_storage_bucket_iam_member.bucket_viewer
  ]
}

resource "kubernetes_persistent_volume_claim_v1" "main" {
  count = var.k8s_pv_claim_name != null ? 1 : 0
  metadata {
    name      = var.k8s_pv_claim_name
    namespace = var.k8s_namespace
    labels = {
      managed_by = "terraform"
    }
  }

  spec {
    access_modes = var.k8s_pv_access_modes
    resources {
      requests = {
        storage = var.k8s_pvc_capacity != null ? var.k8s_pvc_capacity : var.k8s_pv_capacity
      }
    }
    storage_class_name = kubernetes_storage_class_v1.main.metadata[0].name
    volume_name        = kubernetes_persistent_volume_v1.main[0].id
  }
}
