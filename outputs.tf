output "inbox_id" {
  description = "Name of the S3 bucket"
  value       = local.id
}

output "inbox_arn" {
  description = "ARN of the S3 bucket"
  value       = local.arn
}

output "inbox_domain_name" {
  description = "Domain name of the S3 bucket (regional endpoint)"
  value       = local.domain_name
}

output "inbox_region" {
  description = "Region where the S3 bucket is located"
  value       = local.region
}

output "inbox_website_endpoint" {
  description = "Web site endpoint for the S3 bucket"
  value       = local.website
}

output "inbox_s3_endpoint" {
  description = "S3 endpoint for the bucket"
  value       = local.s3_endpoint
}

output "inbox_public_folder_endpoint" {
  description = "Endpoint for the public folder, where you can PUT files"
  value       = "${local.s3_endpoint}/inbox/"
}
