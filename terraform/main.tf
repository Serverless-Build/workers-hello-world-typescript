terraform {
  required_version = ">= 1.6.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.26.0"
    }
  }
}

provider "cloudflare" {}

variable "account_id" {
  type = string
}

variable "workers_subdomain" {
  type = string
}

variable "worker_name" {
  type    = string
  default = "workers-hello-world-typescript-terraform"
}

resource "cloudflare_worker" "hello" {
  account_id    = var.account_id
  name          = var.worker_name
  subdomain     = { enabled = true, previews_enabled = true }
  observability = { enabled = true }
}

resource "cloudflare_worker_version" "hello" {
  account_id          = var.account_id
  worker_id           = cloudflare_worker.hello.id
  compatibility_date  = "2026-09-29"
  compatibility_flags = ["nodejs_compat"]
  main_module         = "index.js"
  modules = [{
    name         = "index.js"
    content_type = "application/javascript+module"
    content_file = "${path.module}/dist/index.js"
  }]
}

resource "cloudflare_workers_deployment" "hello" {
  account_id  = var.account_id
  script_name = cloudflare_worker.hello.name
  strategy    = "percentage"
  versions    = [{ version_id = cloudflare_worker_version.hello.id, percentage = 100 }]
}

output "worker_url" {
  value      = "https://${cloudflare_worker.hello.name}.${var.workers_subdomain}.workers.dev"
  depends_on = [cloudflare_workers_deployment.hello]
}
