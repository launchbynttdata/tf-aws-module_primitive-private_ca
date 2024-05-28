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

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "ecs"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  type        = string
  default     = "us-east-2"
}

variable "key_algorithm" {
  description = "Type of public key algorithm to use for this CA"
  type        = string
  default     = "RSA_4096"
}

variable "signing_algorithm" {
  description = "Name of the algorithm your private CA uses to sign certificate requests."
  type        = string
  default     = "SHA512WITHRSA"
}

variable "subject" {
  description = "Contains information about the certificate subject. Identifies the entity that owns or controls the public key in the certificate. The entity can be a user, computer, device, or service."
  type = object({
    country                      = optional(string)
    distinguished_name_qualifier = optional(string)
    generation_qualifier         = optional(string)
    given_name                   = optional(string)
    initials                     = optional(string)
    locality                     = optional(string)
    organization                 = optional(string)
    organizational_unit          = optional(string)
    state                        = optional(string)
  })
  default = {
    country             = "US"
    organization        = "Launch by NTT DATA"
    state               = "Texas"
    organizational_unit = "DSO"
  }
}

variable "ca_certificate_validity" {
  description = "Configures end of the validity period for the CA ROOT certificate. Defaults to 1 year"
  type = object({
    type  = string
    value = number
  })

  default = {
    type  = "YEARS"
    value = 10
  }
}

variable "tags" {
  description = "A map of custom tags to be associated with the cache cluster"
  type        = map(string)
  default     = {}
}
