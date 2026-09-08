/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// This file was automatically generated from a template in ./autogen/main

data "google_compute_subnetwork" "gke_subnetwork" {
  provider = google

  count   = var.add_cluster_firewall_rules ? 1 : 0
  name    = var.subnetwork
  region  = local.region
  project = local.network_project_id
}

locals {
  # var.private_endpoint_subnetwork is fed straight into private_cluster_config
  # below, which needs the full path (required for Shared VPC, where the
  # subnetwork lives in a different project than the cluster). The
  # google_compute_subnetwork data source's `name` argument below, on the
  # other hand, only accepts the bare subnetwork name - so strip any leading
  # path off it. Works whether callers pass a bare name or a full path.
  # Temper: not yet upstreamed, see https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/2354
  private_endpoint_subnetwork_name = (
    var.private_endpoint_subnetwork != null
    ? element(split("/", var.private_endpoint_subnetwork), length(split("/", var.private_endpoint_subnetwork)) - 1)
    : null
  )
}

data "google_compute_subnetwork" "private_endpoint_subnetwork" {
  provider = google

  count   = var.private_endpoint_subnetwork != null ? 1 : 0
  name    = local.private_endpoint_subnetwork_name
  region  = local.region
  project = local.network_project_id
}
