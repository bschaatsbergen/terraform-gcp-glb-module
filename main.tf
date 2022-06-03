resource "google_compute_global_address" "default" {
  name = "${var.name}-address"

  project = var.project
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "${var.name}-cert"
  managed {
    domains = ["${var.domain}"]
  }

  project  = var.project
  provider = google-beta
}

resource "google_compute_region_network_endpoint_group" "default" {
  for_each = {
    for name, network_endpoint_group in var.network_endpoint_groups : name => network_endpoint_group
    if length(var.network_endpoint_groups) > 0
  }

  name                  = each.value["name"]
  description           = lookup(each.value, "description", null)
  network_endpoint_type = lookup(each.value, "network_endpoint_type", null)
  psc_target_service    = lookup(each.value, "psc_target_service", null)
  region                = each.value["region"]


  #TODO: Add Cloud Function and Serverless Deployments support
  cloud_run {
    service = lookup(each.value, "cloud_run_service", null)
  }

  project  = var.project
  provider = google-beta
}


resource "google_compute_http_health_check" "default" {
  name               = "${var.name}-healthcheck"
  request_path       = var.health_check.request_path
  check_interval_sec = var.health_check.check_interval_sec
  timeout_sec        = var.health_check.timeout_sec

  project = var.project
}


resource "google_compute_backend_service" "default" {
  name = "${var.name}-backend"

  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = "30"

  health_checks = [
    google_compute_http_health_check.default.*.id
  ]

  dynamic "backend" {
    for_each = google_compute_region_network_endpoint_group.default
    content {
      group = backend.value.id
    }
  }

  project = var.project
}

resource "google_compute_url_map" "default" {
  name            = "${var.name}-urlmap"
  default_service = google_compute_backend_service.default.id

  project = var.project
}

resource "google_compute_url_map" "https_redirect" {
  name = "${var.name}-https-redirect-urlmap"
  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }

  project = var.project
}

resource "google_compute_target_http_proxy" "default" {
  name    = "${var.name}-http-proxy"
  url_map = google_compute_url_map.https_redirect.id

  project = var.project
}

resource "google_compute_target_https_proxy" "default" {
  name    = "${var.name}-https-proxy"
  url_map = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.default.id
  ]

  project = var.project
}

resource "google_compute_global_forwarding_rule" "http" {
  name = "${var.name}-http-lb"

  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address

  project = var.project
}

resource "google_compute_global_forwarding_rule" "https" {
  name = "${var.name}-https-lb"

  target     = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_address = google_compute_global_address.default.address

  project = var.project
}
