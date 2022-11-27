output "account_id" {
  description = "AWS Account ID"
  value       = var.account_id
}

output "cloudfront_arn" {
  description = "Cloudfront ARN"
  value       = aws_cloudfront_distribution.cloudfront.arn
}

output "cloudfront_enabled" {
  description = "Cloudfront Enabled status"
  value       = aws_cloudfront_distribution.cloudfront.enabled
}

output "cloudfront_origin" {
  description = "Cloudfront Origin"
  value       = aws_cloudfront_distribution.cloudfront.origin
}

output "cloudfront_domain_name" {
  description = "Cloudfront Domain name"
  value       = aws_cloudfront_distribution.cloudfront.domain_name
}

output "cloudfront_web_acl_id" {
  description = "Cloudfront WAF Web ACL ID"
  value       = aws_cloudfront_distribution.cloudfront.web_acl_id
}

output "cloudfront_aliases" {
  description = "Cloudfront Aliases"
  value       = aws_cloudfront_distribution.cloudfront.aliases
}