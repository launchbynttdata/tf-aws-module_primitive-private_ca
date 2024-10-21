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

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = local.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = join("", split("-", var.region))
  class_env               = var.environment
  cloud_resource_type     = each.value.name
  instance_env            = var.environment_number
  instance_resource       = var.resource_number
  maximum_length          = each.value.max_length
}

resource "aws_acmpca_certificate_authority" "private_ca" {
  certificate_authority_configuration {
    key_algorithm     = var.key_algorithm
    signing_algorithm = var.signing_algorithm


    subject {
      common_name                  = lookup(local.subject, "common_name", "")
      country                      = lookup(local.subject, "country", "")
      distinguished_name_qualifier = lookup(local.subject, "distinguished_name_qualifier", "")
      generation_qualifier         = lookup(local.subject, "generation_qualifier", "")
      given_name                   = lookup(local.subject, "given_name", "")
      initials                     = lookup(local.subject, "initials", "")
      locality                     = lookup(local.subject, "locality", "")
      organization                 = lookup(local.subject, "organization", "")
      organizational_unit          = lookup(local.subject, "organizational_unit", "")
      state                        = lookup(local.subject, "state", "")
    }
  }
  type                            = var.type
  enabled                         = var.enabled
  usage_mode                      = var.usage_mode
  permanent_deletion_time_in_days = var.permanent_deletion_time_in_days

  tags = merge(local.tags, { resource_name = module.resource_names["private_ca"].standard })
}

resource "aws_acmpca_certificate_authority_certificate" "ca_certificate" {
  certificate_authority_arn = aws_acmpca_certificate_authority.private_ca.arn

  certificate       = aws_acmpca_certificate.certificate.certificate
  certificate_chain = aws_acmpca_certificate.certificate.certificate_chain


}

resource "aws_acmpca_certificate" "certificate" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.private_ca.arn
  certificate_signing_request = aws_acmpca_certificate_authority.private_ca.certificate_signing_request
  signing_algorithm           = var.signing_algorithm

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = lookup(var.ca_certificate_validity, "type", "YEARS")
    value = lookup(var.ca_certificate_validity, "value", 1)
  }
}

resource "aws_acmpca_permission" "ca_permission" {
  certificate_authority_arn = aws_acmpca_certificate_authority.private_ca.arn
  actions                   = ["IssueCertificate", "GetCertificate", "ListPermissions"]
  principal                 = "acm.amazonaws.com"
}

data "aws_partition" "current" {}
