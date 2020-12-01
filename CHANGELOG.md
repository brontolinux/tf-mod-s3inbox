# Changelog

## v1.1.0

**WARNING: imcompatible changes**

The boolean input variable `ignore_public_acls` from v1.0.0 has been replaced by `allow_policy_change`, also a boolean. The variable defaults to `false`. As the name of the variable suggests, you must be set it to `true` **before** attempting a policy change, and reset it to `false` when the change is done.

The variable `disable_uploads` has been added. When set to true, the module will modify the bucket policy so that uploading files to the inbox will be forbidden.

Putting the two things together, if uploads are allowed and you want to disable them, you will need to run `terraform apply` three times:

1. change `allow_policy_change` to `true` and run `terraform apply`;
2. change `disable_uploads` to `true` and run `terraform apply` again;
3. change `allow_policy_change` to `false` and run `terraform apply` one last time;

I couldn't think of a better way to get the same result with less `terraform apply` runs. Ideas and patches welcome.

## v1.0.0

First release