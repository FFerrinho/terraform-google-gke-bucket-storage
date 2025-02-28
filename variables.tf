variable "project_id" {
  description = "The project ID."
  type        = string
}

variable "gke_service_account" {
  description = "The name of the GKE Service Account used by the nodes. Can be a custom or default service account."
  type        = string
}

variable "gke_cluster_name" {
  description = "The name of the GKE Cluster."
  type        = string
}

variable "k8s_service_account" {
  description = "The name of the Kubernetes Service Account."
  type        = string
  default     = "gcs-storage-sa"
}

variable "k8s_namespace" {
  description = "The name of the Kubernetes Namespace."
  type        = string
}

variable "k8s_storage_class" {
  description = "The name of the Kubernetes Storage Class."
  type        = string
}

variable "k8s_storage_class_allow_storage_expansion" {
  description = "Allow volume expansion."
  type        = bool
  default     = true
}

variable "k8s_persistent_volume_name" {
  description = "The name of the Kubernetes Persistent Volume."
  type        = string
}

variable "k8s_pv_access_modes" {
  description = "The access modes for the Persistent Volume."
  type        = list(string)
  default     = ["ReadWriteMany"]
}

variable "k8s_pv_capacity" {
  description = "The capacity for the Persistent Volume."
  type        = string
  default     = "100Gi"
}

variable "k8s_pv_read_only" {
  description = "The read only status for the Persistent Volume."
  type        = bool
  default     = false
}

variable "k8s_pv_claim_name" {
  description = "The name of the Persistent Volume Claim."
  type        = string
}

variable "k8s_pv_mount_options" {
  description = "The mount options for the Persistent Volume."
  type        = list(string)
  default     = ["implicit-dirs", "uid=33", "gid=33"]
}
