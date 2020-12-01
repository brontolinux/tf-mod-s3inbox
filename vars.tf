variable "region" {
  description = "AWS region for the resource"
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "name for the inbox bucket"
  type        = string
}

variable "allow_policy_change" {
  description = "Should be always set to false, but you may need to set it to true temporarily before changing the bucket policy"
  default     = false
}

variable "disable_uploads" {
  description = "Update the bucket policy to disable uploads (useful to share data but prevent new uploads in the inbox)"
  default     = false
}

variable "website_index_page" {
  description = "Web site index page"
  default     = "index.html"
}

variable "website_error_page" {
  description = "Web site error page"
  default     = "error.html"
}

variable "routing_rules" {
  description = "Routing rules, see https://docs.aws.amazon.com/AmazonS3/latest/dev/how-to-page-redirect.html#advanced-conditional-redirects"
  default     = "[{\"Condition\":{\"KeyPrefixEquals\":\"/\"},\"Redirect\":{\"ReplaceKeyPrefixWith\":\"index.html\"}}]"
}

variable "tags" {
  description = "Tags to apply to the inbox bucket"
  type        = map
  default     = {}
}

variable "bucket_owners_arns" {
  description = "List of the owners of the inbox bucket in ARN format"
  type        = list
}
