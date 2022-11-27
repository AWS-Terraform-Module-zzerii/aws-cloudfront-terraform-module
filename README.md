# terraform-aws-module-cloudfront

- Aurora CloudFront를 생성하는 공통 모듈

v1.0.4 OAI 직접 지정, logging bucket TRUE
v1.0.5 OAI 직접 지정, logging bucket FALSE

## Usage

### `terraform.tfvars`

- 모든 변수는 적절하게 변경하여 사용

```plaintext
account_id = "123456789012" # 아이디 변경 필수
region     = "ap-northeast-2"

#Cloudfornt web_acl, acm 인증서 사용을 위한 버지니아 리전
virginia_region = "us-east-1"
prefix          = "dev"


oai_path				  = "origin-access-identity/cloudfront/ABCDEFG1234567"

#Cloudfront 배포 상태
enabled                     = true

# 배포 생성
s3_origin_id                = "cf-test-bucket-chaelin"
s3_origin_path              = ""

# include_cookies             = false   # CloudFront에서 액세스 로그에 쿠키를 포함할지 여부
# logging_bucket_name         = "bucket_name"  #액세스 로그를 저장할 Amazon S3 버킷 이름
# logging_prefix              = "example_prefix/"

shield_enabled              = false  #Origin shield 활성화 여부
# origin_shield_region      = "지역 코드"   # enables = true 일 경우

connection_attempts         = 3
connection_timeout          = 10
path_pattern                = "*"  #경로 패턴
compress                    = true  #자동 압축


viewer_protocol_policy      = "redirect-to-https"  #allow-all/https-only/redirect-to-https

allowed_methods             = [ "GET", "HEAD" ]  #GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE
cached_methods              = [ "GET", "HEAD" ]
target_origin_id            = "cf-test-bucket-chaelin"

smooth_streaming            = false

# 사용시 ARN입력
# realtime_log_config_arn   =


custom_error_response       = {
    error-404 = {
        error_caching_min_ttl = 10  #오류 캐싱 최소 TTL 초 단위
        error_code            = 404
        response_code         = 404
        response_page_path    = "/404.html"
    },

    error-500 = {
        error_caching_min_ttl = 10
        error_code            = 500
        response_code         = 500
        response_page_path    = "/500.html"
    },

}

# Settings
price_class                 = "PriceClass_All"  # PriceClass_All/PriceClass_200/PriceClass_100

# 국가별로 콘텐츠 배포를 제한하는 데 사용하려는 방법
restriction_type            = "none"    #none/whitelist/blacklist
# locations                   = ["US", "CA", "GB", "DE"]    # restriction_type none 아닐 경우 지정

##WAF WEB ACL (arn)
#web_acl_name                = "dev-test-waf"

## 대체 도메인 이름 (CNAME)
#aliases                     = ["abcd.com", "www.abcd.com"]

acm_domain                  = "abcd.com"

ssl_support_method          = "sni-only"
# Custom SSL certificate
minimum_protocol_version    = "TLSv1.2_2021"

# 배포에서 지원할 최대 http 버전
http_version                = "http2"

default_root_object         = ""


is_ipv6_enabled             = true
comment                     = ""

tags = {
    "CreatedByTerraform"     = "true"
    "TerraformModuleName"    = "terraform-aws-module-cloudfront"
    "TerraformModuleVersion" = "v1.0.5"
}

```

------

### `main.tf`

```plaintext
module "cloudfront" {
    source                          = "../terraform-aws-module-cloudfront"

    account_id                      = var.account_id
    region                          = var.region
    
    # origin
    virginia_region                 = var.virginia_region
    prefix                          = var.prefix

    oai_path					  = var.oai_path
    
    domain_name                     = data.aws_s3_bucket.s3_origin.bucket_domain_name

    s3_origin_id                    = var.s3_origin_id
    s3_origin_path                  = var.s3_origin_path

    # include_cookies                 = var.include_cookies
    # logging_bucket                  = data.aws_s3_bucket.this.bucket_domain_name
    # logging_prefix                  = var.logging_prefix

    enabled                         = var.enabled

    shield_enabled                  = var.shield_enabled
    origin_shield_region            = var.origin_shield_region

    connection_attempts             = var.connection_attempts
    connection_timeout              = var.connection_timeout

    # cache behavior
    path_pattern                    = var.path_pattern
    compress                        = var.compress
    viewer_protocol_policy          = var.viewer_protocol_policy

    allowed_methods                 = var.allowed_methods
    cached_methods                  = var.cached_methods
    target_origin_id                = var.target_origin_id

    cache_policy_id                 = data.aws_cloudfront_cache_policy.cachingoptimized.id
    origin_request_policy_id        = data.aws_cloudfront_origin_request_policy.allviewer.id
    
    response_headers_policy_id      = data.aws_cloudfront_response_headers_policy.simplecors.id
    smooth_streaming                = var.smooth_streaming

    custom_error_response           = var.custom_error_response

    #Setting
    price_class                     = var.price_class

    restriction_type                = var.restriction_type
    locations                       = var.locations

    # web_acl_id                      = data.aws_wafv2_web_acl.dev-waf.arn

    # aliases                         = var.aliases
    
    acm_certificate_arn             = data.aws_acm_certificate.cf_acm.arn
    ssl_support_method              = var.ssl_support_method
    minimum_protocol_version        = var.minimum_protocol_version

    http_version                    = var.http_version

    default_root_object             = var.default_root_object

    is_ipv6_enabled                 = var.is_ipv6_enabled
    comment                         = var.comment

    current_id                      = data.aws_caller_identity.current.account_id
    current_region                  = data.aws_region.current.name
    tags                            = var.tags
}
```

------

### `provider.tf`

```plaintext
provider "aws" {
   region = var.region
}

# s3 alias aws provider
provider "aws" {
  alias   = "virginia"
  region  = var.virginia_region
}
```

------

### `terraform.tf`

```plaintext
terraform {
  required_version = ">= 1.1.2"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "= 3.74"
    }
  }

  backend "s3" {
    bucket         = "kcl-tf-state-backend"
    key            = "012345678912/cloudfront/terraform.state"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
```

------

### `data.tf`

```plaintext
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}


data "aws_s3_bucket" "s3_origin" {
  bucket      = var.s3_origin_id
}

#data "aws_s3_bucket" "this" {
#    bucket    = var.logging_bucket_name
#}

data "aws_cloudfront_cache_policy" "cachingoptimized" {
  name        = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "cachingdisabled" {
  name        = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "allviewer" {
  name        = "Managed-AllViewer"
}

data "aws_cloudfront_origin_request_policy" "cors3origin" {
  name        = "Managed-CORS-S3Origin"
}

data "aws_cloudfront_response_headers_policy" "simplecors" {
  name        = "Managed-SimpleCORS"
}

# Virginia Provider 지정
#data "aws_wafv2_web_acl" "dev-waf" {
#  provider    = aws.virginia  # set provider
#  name        = var.web_acl_name
#  scope       = "CLOUDFRONT"
#}

data "aws_acm_certificate" "cf_acm" {
  provider    = aws.virginia  # set provider
  domain      = var.acm_domain
  statuses    = ["ISSUED"]
}
```

------

### `variables.tf`

```plaintext
variable "account_id" {
  description = "Allowed AWS account IDs"
  type = string
}

variable "region" {
    type    = string
    default = ""
}
variable "virginia_region" {
    type    = string
    default = ""
}
variable "prefix" {
    type    = string
    default = ""
}

variable "domain_name" {
    type    = string
    default = ""
}

variable "oai_path" {
    type    = string
    default = ""
}

variable "s3_origin_id" {
    type    = string
    default = ""
}

variable "s3_origin_path" {
    type    = string
    default = ""
}

# variable "include_cookies" {
#     type    = bool
#     default = true
# }
# 
# variable "logging_bucket_name" {
#     type    = string
#     default = ""
# }
# 
# variable "logging_prefix" {
#     type    = string
#     default = ""
# }

variable "enabled" {
    type    = bool
    default = true
}

variable "shield_enabled" {
    type    = bool
    default = false
}

variable "origin_shield_region" {
    type = string
    default = ""
  
}

variable "connection_attempts" {
    type    = number
    default = 3
}

variable "connection_timeout" {
    type    = number
    default = 10
}

variable "path_pattern" {
    type    = string
    default = ""
}

variable "compress" {
    type    = bool
    default = true
}

variable "viewer_protocol_policy" {
    type    = string
    default = ""
}

variable "allowed_methods" {
    type    = list(string)
    default = []
}

variable "cached_methods" {
    type    = list(string)
    default = []  
}

variable "target_origin_id" {
    type    = string
    default = ""
}

variable "cache_policy_id" {
    type    = string
    default = ""
}

variable "origin_request_policy_id" {
    type    = string
    default = ""
}

variable "response_headers_policy_id" {
    type    = string
    default = ""
}

variable "smooth_streaming" {
    type    = bool
    default = false
}

variable "custom_error_response" {
    type    = map(any)
    default = {}
}

variable "price_class" {
    type    = string
    default = ""
}

variable "restriction_type" {
    type = string
    default = ""
}

variable "locations" {
    type = list(string)
    default = []
}

#variable "web_acl_name" {
#    type    = string
#    default = null
#}

#variable "aliases" {
#    type    = list(string)
#    default = null
#}

variable "acm_domain" {
    type    = string
    default = ""
}

variable "acm_certificate_arn" {
    type    = string
    default = ""
}

variable "ssl_support_method" {
    type = string
    default = ""
}

variable "minimum_protocol_version" {
    type    = string
    default = ""
}

variable "http_version" {
    type    = string
    default = ""
}

variable "default_root_object" {
    type    = string
    default = ""
}

variable "is_ipv6_enabled" {
    type    = bool
    default = true
}

variable "comment" {
    type    = string
    default = ""
}

variable "tags" {
  type        = map(string)
}

```

------

### `outputs.tf`

```plaintext
output "result" {
    value = module.cloudfront
}
```

## 실행방법

```plaintext
terraform init -get=true -upgrade -reconfigure
terraform validate (option)
terraform plan -var-file=terraform.tfvars -refresh=false -out=planfile
terraform apply planfile
```

- "Objects have changed outside of Terraform" 때문에 `-refresh=false`를 사용
- 실제 UI에서 리소스 변경이 없어보이는 것과 low-level Terraform에서 Object 변경을 감지하는 것에 차이가 있는 것 같음, 다음 링크 참고
  - https://github.com/hashicorp/terraform/issues/28776
- 위 이슈로 변경을 감지하고 리소스를 삭제하는 케이스가 발생 할 수 있음