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

output "private_ca_arn" {
  description = "ARN of Private CA"
  value       = module.pca.private_ca_arn
}

output "private_ca_id" {
  description = "ID of the private CA"
  value       = module.pca.private_ca_id
}

output "resource_name_tag" {
  value = module.pca.resource_name_tag
}

output "private_ca_type" {
  description = "Type of the private CA"
  value       = module.pca.private_ca_type
}

output "private_ca_usage_mode" {
  description = "Usage mode of the private CA"
  value       = module.pca.private_ca_usage_mode
}

output "private_ca_key_algorithm" {
  description = "Configuration of the private CA"
  value       = module.pca.private_ca_key_algorithm
}

output "private_ca_signing_algorithm" {
  description = "Configuration of the private CA"
  value       = module.pca.private_ca_signing_algorithm
}
