variable "account_id" {
  description = "Allowed AWS account IDs"
  type        = string
}

variable "current_region" {
  type        = string
}

variable "current_id" {
  type        = string
}

variable "region" {
    type    = string
}

variable "virginia_region" {
    type    = string
}

variable "prefix" {
    type    = string
}

variable "domain_name" {
    type    = string
}

variable "oai_path" {
    type    = string
}

variable "s3_origin_id" {
    type    = string
}

variable "s3_origin_path" {
    type    = string
}

# variable "include_cookies" {
#     type    = bool
#     default = null
# }

# variable "logging_bucket" {
#     type    = string
#     default = null
# }

# variable "logging_prefix" {
#     type    = string
#     default = null
# }

variable "enabled" {
    type    = bool
}

variable "shield_enabled" {
    type    = bool
}

variable "origin_shield_region" {
    type    = string
}

variable "connection_attempts" {
    type    = number
}

variable "connection_timeout" {
    type    = number
}

variable "path_pattern" {
    type    = string
}

variable "compress" {
    type    = bool
}

variable "viewer_protocol_policy" {
    type    = string
}

variable "allowed_methods" {
    type    = list(string)
}

variable "cached_methods" {
    type    = list(string)  
}

variable "target_origin_id" {
    type    = string
}

variable "cache_policy_id" {
    type    = string
}

variable "origin_request_policy_id" {
    type    = string
}

variable "response_headers_policy_id" {
    type    = string
}

variable "smooth_streaming" {
    type    = bool
}

variable "custom_error_response" {
    type    = map(any)
}

variable "price_class" {
    type    = string
}

variable "restriction_type" {
    type    = string
}

variable "locations" {
    type    = list(string)
}


# variable "web_acl_id" {
#     type    = string
# }

variable "aliases" {
    type    = list(string)
}

variable "acm_certificate_arn" {
    type    = string
}

variable "ssl_support_method" {
    type    = string
  
}

variable "minimum_protocol_version" {
    type    = string
}

variable "http_version" {
    type    = string

}

variable "default_root_object" {
    type    = string

}

variable "is_ipv6_enabled" {
    type    = bool
}

variable "comment" {
    type    = string
}

variable "tags" {
  type      = map(string)
}
