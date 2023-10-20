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

output "resource_name_tag" {
  value = module.resource_names["private_ca"].standard
}

output "private_ca_arn" {
  description = "ARN of Private CA"
  value       = aws_acmpca_certificate_authority.private_ca.arn
}

output "private_ca_id" {
  description = "ID of the private CA"
  value       = aws_acmpca_certificate_authority.private_ca.id
}
