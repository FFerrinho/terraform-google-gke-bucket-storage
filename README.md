## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2 |

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
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | The name of the GKE Cluster. | `string` | n/a | yes |
| <a name="input_gke_service_account"></a> [gke\_service\_account](#input\_gke\_service\_account) | The name of the GKE Service Account used by the nodes. Can be a custom or default service account. | `string` | n/a | yes |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | The name of the Kubernetes Namespace. | `string` | n/a | yes |
| <a name="input_k8s_persistent_volume_name"></a> [k8s\_persistent\_volume\_name](#input\_k8s\_persistent\_volume\_name) | The name of the Kubernetes Persistent Volume. | `string` | n/a | yes |
| <a name="input_k8s_pv_access_modes"></a> [k8s\_pv\_access\_modes](#input\_k8s\_pv\_access\_modes) | The access modes for the Persistent Volume. | `list(string)` | <pre>[<br>  "ReadWriteMany"<br>]</pre> | no |
| <a name="input_k8s_pv_capacity"></a> [k8s\_pv\_capacity](#input\_k8s\_pv\_capacity) | The capacity for the Persistent Volume. | `string` | `"100Gi"` | no |
| <a name="input_k8s_pv_claim_name"></a> [k8s\_pv\_claim\_name](#input\_k8s\_pv\_claim\_name) | The name of the Persistent Volume Claim. | `string` | n/a | yes |
| <a name="input_k8s_pv_mount_options"></a> [k8s\_pv\_mount\_options](#input\_k8s\_pv\_mount\_options) | The mount options for the Persistent Volume. | `list(string)` | <pre>[<br>  "implicit-dirs",<br>  "uid=33",<br>  "gid=33"<br>]</pre> | no |
| <a name="input_k8s_pv_read_only"></a> [k8s\_pv\_read\_only](#input\_k8s\_pv\_read\_only) | The read only status for the Persistent Volume. | `bool` | `false` | no |
| <a name="input_k8s_service_account"></a> [k8s\_service\_account](#input\_k8s\_service\_account) | The name of the Kubernetes Service Account. | `string` | `"gcs-storage-sa"` | no |
| <a name="input_k8s_storage_class"></a> [k8s\_storage\_class](#input\_k8s\_storage\_class) | The name of the Kubernetes Storage Class. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID. | `string` | n/a | yes |
| <a name="input_k8s_storage_class_allow_storage_expansion"></a> [storage\_class\_allow\_storage\_expansion](#input\_storage\_class\_allow\_storage\_expansion) | Allow volume expansion. | `bool` | `true` | no |

## Outputs

No outputs.
