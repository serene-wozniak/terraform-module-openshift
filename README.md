# terraform-module-openshift

## Getting started

Notice that the following steps are based on terraform configuration file found in example directory

0. Setup aws configuration properly

- it means config file, credentials, terraform provider. 

Example of assuming role command 

```
aws sts assume-role --role-session-name "demo" --role-arn $(aws configure --profile $1 get role_arn) --serial-number $(aws configure --profile $1 get mfa_serial) --token-code $2 --debug | tee \
  >(jq '.Credentials.SecretAccessKey' | xargs printf "export AWS_SECRET_ACCESS_KEY=%s\n") \
  >(jq '.Credentials.AccessKeyId' | xargs printf "export AWS_ACCESS_KEY_ID=%s \n") \
  >(jq '.Credentials.SessionToken' | xargs printf "export AWS_SESSION_TOKEN=%s\n") > /dev/null
```


1. Bootstraping modules with `terraform get`
````
Enekos-MacBook-Pro:terraform-module-openshift eneko$ terraform get example/
Get: file:///Users/eneko/projects/serene-wozniak/terraform-module-openshift/terraform
Get: git::ssh://git@github.com/serene-wozniak/terraform-module-bootstrap.git?ref=post_provision
Get: git::ssh://git@github.com/serene-wozniak/terraform-module-bootstrap.git?ref=post_provision
Get: git::ssh://git@github.com/serene-wozniak/terraform-module-bootstrap.git?ref=post_provision
````
2. Init terraform backend with `terraform init`

```
eneko$ terraform init example/

Initializing configuration from: "example/"...
Downloading modules (if any)...
Get: file:///Users/eneko/projects/serene-wozniak/terraform
Get: git::ssh://git@github.com/serene-wozniak/terraform-module-bootstrap.git?ref=post_provision
Get: git::ssh://git@github.com/serene-wozniak/terraform-module-bootstrap.git?ref=post_provision
Get: git::ssh://git@github.com/serene-wozniak/terraform-module-bootstrap.git?ref=post_provision
Initializing the backend...


Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your environment. If you forget, other
commands will detect it and remind you to do so if necessary.
````

3. Plan resource changes with `terraform plan -out=terraform.out -var-file=openshift-ggcommontest.terraform.tfvars`
