# Terraform GCP Global HTTP(S) Load balancer module

Module that features the creation of a Global HTTP(S) Load Balancer in GCP.

### Features

### Usage

```terraform
module "global_lb" {
  source = "github.com/bschaatsbergen/terraform-gcp-glb-module"

  name   = var.name
  domain = var.domain
  network_endpoint_groups = [
    {
      name              = "default-endpoint-group"
      cloud_run_service = google_cloud_run_service.default.name
      region            = google_cloud_run_service.default.location
    }
  ]

  project = var.project
}

# Add the load balancer IP to the managed Cloud DNS zone
resource "google_dns_record_set" "default" {
  name = "example.com."
  type = "A"
  ttl  = 60

  managed_zone = google_dns_managed_zone.default.name

  rrdatas = [
    module.global_lb.ip_address
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.22.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | 4.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_managed_ssl_certificate.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_managed_ssl_certificate) | resource |
| [google-beta_google_compute_region_network_endpoint_group.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_network_endpoint_group) | resource |
| [google_compute_backend_service.default](https://registry.terraform.io/providers/hashicorp/google/4.22.0/docs/resources/compute_backend_service) | resource |
| [google_compute_global_address.default](https://registry.terraform.io/providers/hashicorp/google/4.22.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_forwarding_rule.http](https://registry.terraform.io/providers/hashicorp/google/4.22.0/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_global_forwarding_rule.https](https://registry.terraform.io/providers/hashicorp/google/4.22.0/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_http_health_check.default](https://registry.terraform.io/providers/hashicorp/google/4.22.0/docs/resources/compute_http_health_check) | resource |
| [google_compute_target_http_proxy.default](https://registry.terraform.io/providers/hashicorp/google/4.22.0/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_target_https_proxy.default](https://registry.terraform.io/providers/hashicorp/google/4.22.0/docs/resources/compute_target_https_proxy) | resource |
| [google_compute_url_map.default](https://registry.terraform.io/providers/hashicorp/google/4.22.0/docs/resources/compute_url_map) | resource |
| [google_compute_url_map.https_redirect](https://registry.terraform.io/providers/hashicorp/google/4.22.0/docs/resources/compute_url_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | Domain of the service | `string` | `null` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health check configuration | <pre>object({<br>    request_path       = string<br>    check_interval_sec = number<br>    timeout_sec        = number<br>  })</pre> | <pre>{<br>  "check_interval_sec": 5,<br>  "request_path": "/",<br>  "timeout_sec": 5<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the service | `string` | n/a | yes |
| <a name="input_network_endpoint_groups"></a> [network\_endpoint\_groups](#input\_network\_endpoint\_groups) | Network endpoint groups to create | `list(map(string))` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Project where the Cloud Run resources are being created | `string` | `"null"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | The IPv4 address of the load balancer |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
