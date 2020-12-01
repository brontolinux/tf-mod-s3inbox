/**
* # S3 inbox bucket
*
* This module configures an inbox bucket in S3. An inbox is basically a website hosted on an S3 bucket with a public directory called `inbox`. Anyone can put files in the inbox, but they cannot be listed or retrieved by anyone but the entities whose ARNs have been defined as owners of the inbox.
*
*
* # WARNING!!! 
* 
* The fact that the inbox cannot be read and files cannot be fetched prevents it from being exploited for illegal file
* sharing. However, **nothing will prevent anyone from filling your inbox with crap** and make you pay for the storage. For this reason, **it is recommended that you either bring the inbox up and down at need** or that you **implement additional security to prevent abuse**.
*
* If, despite the warning, you decide to keep your inbox around, **you take full responsibility for any unexpected cost you may incur**.
*/

# To generate the documentation, use
# terraform-docs --escape=false markdown document

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

locals {
  id           = module.inbox.this_s3_bucket_id
  arn          = module.inbox.this_s3_bucket_arn
  domain_name  = module.inbox.this_s3_bucket_bucket_regional_domain_name
  region       = module.inbox.this_s3_bucket_region
  website      = "http://${module.inbox.this_s3_bucket_website_endpoint}"
  s3_endpoint  = "https://${local.domain_name}"
  inbox_policy = var.disable_uploads ? "Deny" : "Allow"
  tight_acl    = var.allow_policy_change ? false : true
}

module "inbox" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "1.16.0"

  bucket        = var.bucket_name
  create_bucket = true
  force_destroy = true

  acl = "private"

  # To understand the meaning of these, the Terraform documentation is way more helpful
  # than the corresponding AWS documentation, believe me
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
  # All directives default to false
  block_public_acls       = false
  block_public_policy     = local.tight_acl
  ignore_public_acls      = local.tight_acl
  restrict_public_buckets = false

  attach_policy = true
  policy        = data.aws_iam_policy_document.inbox.json

  website = {
    index_document = var.website_index_page
    error_document = var.website_error_page
    routing_rules  = var.routing_rules
  }

  tags = var.tags
}

data "aws_iam_policy_document" "inbox" {
  statement {
    sid = "AllowOwnerAll"

    principals {
      type        = "AWS"
      identifiers = var.bucket_owners_arns
    }

    resources = [
      local.arn,
      "${local.arn}/*",
      "${local.arn}/inbox/*"
    ]

    actions = [
      "s3:*"
    ]

    effect = "Allow"
  }

  statement {
    sid = "AllowAnonymousGet"

    not_principals {
      type        = "AWS"
      identifiers = var.bucket_owners_arns
    }

    not_resources = [
      "${local.arn}/inbox/*"
    ]

    actions = [
      "s3:GetObject"
    ]

    effect = "Allow"
  }

  statement {
    sid = "${local.inbox_policy}AnonymousPutInbox"

    not_principals {
      type        = "AWS"
      identifiers = var.bucket_owners_arns
    }


    resources = [
      "${local.arn}/inbox/*"
    ]

    actions = [
      "s3:PutObject"
    ]

    effect = local.inbox_policy
  }

  statement {
    sid = "DenyAnonymousAllInbox"

    not_principals {
      type        = "AWS"
      identifiers = var.bucket_owners_arns
    }

    resources = [
      "${local.arn}/inbox/*"
    ]

    not_actions = [
      "s3:PutObject"
    ]

    effect = "Deny"
  }
}
