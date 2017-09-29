# terraform-module-openshift


This module provides a complete openshift origin cluster.


It uses the terraform env functionality - to get started, clone this repo, change into the implementation folder and run `terraform env list`.

```
* default
  ggcommontest
  ggdestest
  ggmoneytest
```

You can switch between these environments with
```terraform select <envname>```

Please keep default as empty state, to prevent accidental deletion.


## Prerequsites

1. An S3 bucket called `<AWS_ACCOUNT_ID>-terraform-state` that you can write to as PowerUser
1. The giffgaff standard network layout state in that bucket. (See https://github.com/serene-wozniak/terraform-module-ggnetwork for details)
1. Access to the tfvars file in keybase. (Ask Saflin/Miles)

## Setting up a new cluster

1. Login to a PowerUserAccess role in your target AWS account via the okta cli.
1. Change into the implementation directory: `cd implementation`
1. Place the `terraform.tfvars` file from keybase in the implementation directory
1. Run `terraform env new <clustername>`
1. `terraform plan` to validate the setup
1. `terraform apply` to create the resource
1. Progress can then be monitored by running `ssh -l centos openshift-bootstrapper.<clustername>.aws.int.giffgaff.co.uk` and then tailing `/var/log/cloud-init-output.log`
