# complete

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_pca"></a> [pca](#module\_pca) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"ecs"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region in which the infra needs to be provisioned | `string` | `"us-east-2"` | no |
| <a name="input_key_algorithm"></a> [key\_algorithm](#input\_key\_algorithm) | Type of public key algorithm to use for this CA | `string` | `"RSA_4096"` | no |
| <a name="input_signing_algorithm"></a> [signing\_algorithm](#input\_signing\_algorithm) | Name of the algorithm your private CA uses to sign certificate requests. | `string` | `"SHA512WITHRSA"` | no |
| <a name="input_subject"></a> [subject](#input\_subject) | Contains information about the certificate subject. Identifies the entity that owns or controls the public key in the certificate. The entity can be a user, computer, device, or service. | <pre>object({<br>    country                      = optional(string)<br>    distinguished_name_qualifier = optional(string)<br>    generation_qualifier         = optional(string)<br>    given_name                   = optional(string)<br>    initials                     = optional(string)<br>    locality                     = optional(string)<br>    organization                 = optional(string)<br>    organizational_unit          = optional(string)<br>    state                        = optional(string)<br>  })</pre> | <pre>{<br>  "country": "US",<br>  "organization": "Launch by NTT DATA",<br>  "organizational_unit": "DSO",<br>  "state": "Texas"<br>}</pre> | no |
| <a name="input_ca_certificate_validity"></a> [ca\_certificate\_validity](#input\_ca\_certificate\_validity) | Configures end of the validity period for the CA ROOT certificate. Defaults to 1 year | <pre>object({<br>    type  = string<br>    value = number<br>  })</pre> | <pre>{<br>  "type": "YEARS",<br>  "value": 10<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of custom tags to be associated with the cache cluster | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_ca_arn"></a> [private\_ca\_arn](#output\_private\_ca\_arn) | ARN of Private CA |
| <a name="output_private_ca_id"></a> [private\_ca\_id](#output\_private\_ca\_id) | ID of the private CA |
| <a name="output_resource_name_tag"></a> [resource\_name\_tag](#output\_resource\_name\_tag) | n/a |
| <a name="output_private_ca_type"></a> [private\_ca\_type](#output\_private\_ca\_type) | Type of the private CA |
| <a name="output_private_ca_usage_mode"></a> [private\_ca\_usage\_mode](#output\_private\_ca\_usage\_mode) | Usage mode of the private CA |
| <a name="output_private_ca_key_algorithm"></a> [private\_ca\_key\_algorithm](#output\_private\_ca\_key\_algorithm) | Configuration of the private CA |
| <a name="output_private_ca_signing_algorithm"></a> [private\_ca\_signing\_algorithm](#output\_private\_ca\_signing\_algorithm) | Configuration of the private CA |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
