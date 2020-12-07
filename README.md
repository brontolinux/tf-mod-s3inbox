# S3 inbox bucket

This module configures an inbox bucket in S3. An inbox is basically a website hosted on an S3 bucket with a public directory called `inbox`. Anyone can put files in the inbox, but they cannot be listed or retrieved by anyone but the entities whose ARNs have been defined as owners of the inbox.

# WARNING!!!

The fact that the inbox cannot be read and files cannot be fetched prevents it from being exploited for illegal file  
sharing. However, **nothing will prevent anyone from filling your inbox with crap** and make you pay for the storage. For this reason, **it is recommended that you either bring the inbox up and down at need** or that you **implement additional security to prevent abuse**.

If, despite the warning, you decide to keep your inbox around, **you take full responsibility for any unexpected cost you may incur**.

## Requirements

The following requirements are needed by this module:

- terraform (>= 0.13)

- aws (~> 3.15.0)

## Providers

The following providers are used by this module:

- aws (~> 3.15.0)

## Required Inputs

The following input variables are required:

### bucket_name

Description: name for the inbox bucket

Type: `string`

### bucket_owners_arns

Description: List of the owners of the inbox bucket in ARN format

Type: `list`

## Optional Inputs

The following input variables are optional (have default values):

### allow_policy_change

Description: Should be always set to false, but you may need to set it to true temporarily before changing the bucket policy

Type: `bool`

Default: `false`

### disable_uploads

Description: Update the bucket policy to disable uploads (useful to share data but prevent new uploads in the inbox)

Type: `bool`

Default: `false`

### region

Description: AWS region for the resource

Type: `string`

Default: `"eu-west-1"`

### routing_rules

Description: Routing rules, see https://docs.aws.amazon.com/AmazonS3/latest/dev/how-to-page-redirect.html#advanced-conditional-redirects

Type: `string`

Default: `"[{\"Condition\":{\"KeyPrefixEquals\":\"/\"},\"Redirect\":{\"ReplaceKeyPrefixWith\":\"index.html\"}}]"`

### tags

Description: Tags to apply to the inbox bucket

Type: `map`

Default: `{}`

### website_error_page

Description: Web site error page

Type: `string`

Default: `"error.html"`

### website_index_page

Description: Web site index page

Type: `string`

Default: `"index.html"`

## Outputs

The following outputs are exported:

### inbox_arn

Description: ARN of the S3 bucket

### inbox_domain_name

Description: Domain name of the S3 bucket (regional endpoint)

### inbox_id

Description: Name of the S3 bucket

### inbox_public_folder_endpoint

Description: Endpoint for the public folder, where you can PUT files

### inbox_region

Description: Region where the S3 bucket is located

### inbox_s3_endpoint

Description: S3 endpoint for the bucket

### inbox_website_endpoint

Description: Web site endpoint for the S3 bucket

