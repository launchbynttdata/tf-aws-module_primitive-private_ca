// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "pca" {
  source = "../.."

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = var.region
  environment             = var.environment
  environment_number      = var.environment_number
  resource_number         = var.resource_number

  key_algorithm           = var.key_algorithm
  signing_algorithm       = var.signing_algorithm
  subject                 = var.subject
  ca_certificate_validity = var.ca_certificate_validity

  tags = var.tags
}
