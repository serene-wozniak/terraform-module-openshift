provider "aws" {
  region = "eu-west-1"
}

resource "aws_iam_role" "oc-jenkins-role" {
  name = "oc-jenkins-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "access_other_accounts" {
  name = "oc-jenkins-roleaccess"
  role = "${aws_iam_role.oc-jenkins-role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Resource": "arn:aws:iam::841990667482:role/PowerUserAccess"
        },
        {
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Resource": "arn:aws:iam::604083106117:role/DNSMgr"
        },
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::528557666825:role/SvcECRAdmin"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "access_my_account" {
  name = "oc-jenkins-controlaccess"
  role = "${aws_iam_role.oc-jenkins-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Resource": "*",
      "NotAction": [
        "iam:AttachUserPolicy",
        "iam:ChangePassword",
        "iam:CreateAccessKey",
        "iam:CreateAccountAlias",
        "iam:CreateGroup",
        "iam:CreateLoginProfile",
        "iam:CreateOpenIDConnectProvider",
        "iam:CreatePolicyVersion",
        "iam:CreateSAMLProvider",
        "iam:CreateUser",
        "iam:CreateVirtualMFADevice",
        "iam:DeactivateMFADevice",
        "iam:DeleteAccessKey",
        "iam:DeleteAccountAlias",
        "iam:DeleteAccountPasswordPolicy",
        "iam:DeleteGroup",
        "iam:DeleteGroupPolicy",
        "iam:DeleteLoginProfile",
        "iam:DeleteOpenIDConnectProvider",
        "iam:DeletePolicy",
        "iam:DeletePolicyVersion",
        "iam:DeleteSAMLProvider",
        "iam:DeleteSSHPublicKey",
        "iam:DeleteServerCertificate",
        "iam:DeleteSigningCertificate",
        "iam:DeleteUser",
        "iam:DeleteUserPolicy",
        "iam:DeleteVirtualMFADevice",
        "iam:DetachGroupPolicy",
        "iam:DetachUserPolicy",
        "iam:EnableMFADevice",
        "iam:GenerateCredentialReport",
        "iam:GenerateServiceLastAccessedDetails",
        "iam:PutGroupPolicy",
        "iam:PutUserPolicy",
        "iam:RemoveClientIDFromOpenIDConnectProvider",
        "iam:RemoveUserFromGroup",
        "iam:ResyncMFADevice",
        "iam:SetDefaultPolicyVersion",
        "iam:SimulatePrincipalPolicy",
        "iam:UpdateAccessKey",
        "iam:UpdateAccountPasswordPolicy",
        "iam:UpdateAssumeRolePolicy",
        "iam:UpdateGroup",
        "iam:UpdateLoginProfile",
        "iam:UpdateOpenIDConnectProviderThumbprint",
        "iam:UpdateSAMLProvider",
        "iam:UpdateSSHPublicKey",
        "iam:UpdateServerCertificate",
        "iam:UpdateSigningCertificate",
        "iam:UpdateUser",
        "iam:UploadSSHPublicKey",
        "iam:UploadServerCertificate",
        "iam:UploadSigningCertificate"
      ],
      "Effect": "Allow",
      "Sid": "AllowAllButSomeIAMActions"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "oc-jenkins" {
  name  = "oc-jenkins"
  role = "${aws_iam_role.oc-jenkins-role.name}"
}
