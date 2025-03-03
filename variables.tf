variable "project_id" {
  description = "The Google Cloud Project ID where resources will be created."
  type        = string
}

variable "gke_service_account_email" {
  description = "The email of the GCP Service Account used by GKE nodes. This can be either the default compute service account or a custom service account."
  type        = string
}

variable "gke_cluster_name" {
  description = "The name of the GKE Cluster where the GCS Fuse CSI driver is installed."
  type        = string
}

variable "bucket_name" {
  description = "The name of the existing Google Cloud Storage Bucket to mount."
  type        = string
}

variable "k8s_service_account_name" {
  description = "The name of the Kubernetes Service Account that will be used to access the GCS bucket through Workload Identity."
  type        = string
}

variable "create_k8s_service_account" {
  description = "Whether to create a new Kubernetes Service Account and bind it to the GCP Service Account. Set to false if you already have a service account configured with Workload Identity."
  type        = bool
  default     = true
}

variable "k8s_namespace" {
  description = "The Kubernetes Namespace where the Service Account, PVC, and other resources will be created."
  type        = string
}

variable "k8s_storage_class" {
  description = "The name of the Kubernetes Storage Class that will be created for the GCS Fuse CSI driver."
  type        = string
}

variable "k8s_storage_class_allow_storage_expansion" {
  description = "Whether to allow volume expansion in the Storage Class. This enables dynamic resizing of persistent volumes."
  type        = bool
  default     = true
}

variable "k8s_persistent_volume_name" {
  description = "The name of the Kubernetes Persistent Volume that will be created to represent the GCS bucket."
  type        = string
}

variable "k8s_pv_access_modes" {
  description = "The access modes for the Persistent Volume. Default is ReadWriteMany to allow multiple pods to mount the same bucket."
  type        = list(string)
  default     = ["ReadWriteMany"]
}

variable "k8s_pv_capacity" {
  description = "The storage capacity to report for the Persistent Volume. This doesn't limit the actual GCS bucket size."
  type        = string
  default     = "100Gi"
}

variable "k8s_pv_read_only" {
  description = "Whether to mount the GCS bucket as read-only in the Persistent Volume."
  type        = bool
  default     = false
}

variable "k8s_pv_claim_name" {
  description = "The name of the Persistent Volume Claim that will be created to bind to the Persistent Volume."
  type        = string
}

variable "k8s_pv_mount_options" {
  description = "Mount options for the GCS Fuse CSI driver. Default includes implicit-dirs for better directory handling and uid/gid 33 for www-data user compatibility."
  type        = list(string)
  default     = ["implicit-dirs"]
}
