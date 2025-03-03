## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.23.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.36.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_service_account_iam_binding.gcs-fuse-csi-sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_storage_bucket_iam_member.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [kubernetes_persistent_volume.main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume) | resource |
| [kubernetes_persistent_volume_claim_v1.main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim_v1) | resource |
| [kubernetes_service_account_v1.main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |
| [kubernetes_storage_class_v1.main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [google_project.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the existing Google Cloud Storage Bucket to mount. | `string` | n/a | yes |
| <a name="input_create_k8s_service_account"></a> [create\_k8s\_service\_account](#input\_create\_k8s\_service\_account) | Whether to create a new Kubernetes Service Account and bind it to the GCP Service Account. Set to false if you already have a service account configured with Workload Identity. | `bool` | `true` | no |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | The name of the GKE Cluster where the GCS Fuse CSI driver is installed. | `string` | n/a | yes |
| <a name="input_gke_service_account_email"></a> [gke\_service\_account\_email](#input\_gke\_service\_account\_email) | The email of the GCP Service Account used by GKE nodes. This can be either the default compute service account or a custom service account. | `string` | n/a | yes |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | The Kubernetes Namespace where the Service Account, PVC, and other resources will be created. | `string` | n/a | yes |
| <a name="input_k8s_persistent_volume_name"></a> [k8s\_persistent\_volume\_name](#input\_k8s\_persistent\_volume\_name) | The name of the Kubernetes Persistent Volume that will be created to represent the GCS bucket. | `string` | n/a | yes |
| <a name="input_k8s_pv_access_modes"></a> [k8s\_pv\_access\_modes](#input\_k8s\_pv\_access\_modes) | The access modes for the Persistent Volume. Default is ReadWriteMany to allow multiple pods to mount the same bucket. | `list(string)` | <pre>[<br>  "ReadWriteMany"<br>]</pre> | no |
| <a name="input_k8s_pv_capacity"></a> [k8s\_pv\_capacity](#input\_k8s\_pv\_capacity) | The storage capacity to report for the Persistent Volume. This doesn't limit the actual GCS bucket size. | `string` | `"100Gi"` | no |
| <a name="input_k8s_pv_claim_name"></a> [k8s\_pv\_claim\_name](#input\_k8s\_pv\_claim\_name) | The name of the Persistent Volume Claim that will be created to bind to the Persistent Volume. | `string` | n/a | yes |
| <a name="input_k8s_pv_mount_options"></a> [k8s\_pv\_mount\_options](#input\_k8s\_pv\_mount\_options) | Mount options for the GCS Fuse CSI driver. Default includes implicit-dirs for better directory handling and uid/gid 33 for www-data user compatibility. | `list(string)` | <pre>[<br>  "implicit-dirs"<br>]</pre> | no |
| <a name="input_k8s_pv_read_only"></a> [k8s\_pv\_read\_only](#input\_k8s\_pv\_read\_only) | Whether to mount the GCS bucket as read-only in the Persistent Volume. | `bool` | `false` | no |
| <a name="input_k8s_service_account_name"></a> [k8s\_service\_account\_name](#input\_k8s\_service\_account\_name) | The name of the Kubernetes Service Account that will be used to access the GCS bucket through Workload Identity. | `string` | n/a | yes |
| <a name="input_k8s_storage_class"></a> [k8s\_storage\_class](#input\_k8s\_storage\_class) | The name of the Kubernetes Storage Class that will be created for the GCS Fuse CSI driver. | `string` | n/a | yes |
| <a name="input_k8s_storage_class_allow_storage_expansion"></a> [k8s\_storage\_class\_allow\_storage\_expansion](#input\_k8s\_storage\_class\_allow\_storage\_expansion) | Whether to allow volume expansion in the Storage Class. This enables dynamic resizing of persistent volumes. | `bool` | `true` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The Google Cloud Project ID where resources will be created. | `string` | n/a | yes |

## Outputs

No outputs.
