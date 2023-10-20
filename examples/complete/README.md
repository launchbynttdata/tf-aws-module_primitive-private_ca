# complete

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

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
| <a name="input_naming_prefix"></a> [naming\_prefix](#input\_naming\_prefix) | Prefix for the provisioned resources. | `string` | `"demo-pca"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region in which the infra needs to be provisioned | `string` | `"us-east-2"` | no |
| <a name="input_key_algorithm"></a> [key\_algorithm](#input\_key\_algorithm) | Type of public key algorithm to use for this CA | `string` | `"RSA_4096"` | no |
| <a name="input_signing_algorithm"></a> [signing\_algorithm](#input\_signing\_algorithm) | Name of the algorithm your private CA uses to sign certificate requests. | `string` | `"SHA512WITHRSA"` | no |
| <a name="input_subject"></a> [subject](#input\_subject) | Contains information about the certificate subject. Identifies the entity that owns or controls the public key in the certificate. The entity can be a user, computer, device, or service. | <pre>object({<br>    country                      = optional(string)<br>    distinguished_name_qualifier = optional(string)<br>    generation_qualifier         = optional(string)<br>    given_name                   = optional(string)<br>    initials                     = optional(string)<br>    locality                     = optional(string)<br>    organization                 = optional(string)<br>    organizational_unit          = optional(string)<br>    state                        = optional(string)<br>  })</pre> | <pre>{<br>  "country": "US",<br>  "organization": "Launch by NTT DATA",<br>  "organizational_unit": "DSO",<br>  "state": "Texas"<br>}</pre> | no |
| <a name="input_permanent_deletion_time_in_days"></a> [permanent\_deletion\_time\_in\_days](#input\_permanent\_deletion\_time\_in\_days) | Number of days to make a CA restorable after it has been deleted,<br>    must be between 7 to 30 days, with default to 30 days. | `number` | `7` | no |
| <a name="input_usage_mode"></a> [usage\_mode](#input\_usage\_mode) | Specifies whether the CA issues general-purpose certificates that typically require a revocation mechanism,<br>    or short-lived certificates that may optionally omit revocation because they expire quickly. | `string` | `"GENERAL_PURPOSE"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the certificate authority is enabled or disabled. | `bool` | `true` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of the certificate authority. Defaults to SUBORDINATE. Valid values: ROOT and SUBORDINATE. | `string` | `"ROOT"` | no |
| <a name="input_ca_certificate_validity"></a> [ca\_certificate\_validity](#input\_ca\_certificate\_validity) | Configures end of the validity period for the CA ROOT certificate. Defaults to 1 year | <pre>object({<br>    type  = string<br>    value = number<br>  })</pre> | <pre>{<br>  "type": "YEARS",<br>  "value": 10<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of custom tags to be associated with the cache cluster | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_ca_arn"></a> [private\_ca\_arn](#output\_private\_ca\_arn) | ARN of Private CA |
| <a name="output_private_ca_id"></a> [private\_ca\_id](#output\_private\_ca\_id) | ID of the private CA |
| <a name="output_resource_name_tag"></a> [resource\_name\_tag](#output\_resource\_name\_tag) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
