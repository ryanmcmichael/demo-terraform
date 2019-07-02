resource "aws_iam_user" "user" {
  name = "${var.user_name}"
  path = "${var.user_path}"
}

resource "aws_iam_user_ssh_key" "user" {
  count      = "${var.user_ssh_pub == "none" ? 0 : 1}"
  username   = "${var.user_name}"
  encoding   = "SSH"
  public_key = "${var.user_ssh_pub}"
}

resource "aws_iam_user_policy" "user" {
  name = "UserProfileSelfService"
  user = "${aws_iam_user.user.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowUsersToManageTheirOwnLoginProfileAccessKeySSHPublickKey",
      "Effect": "Allow",
      "Action": [
        "iam:*LoginProfile*",
        "iam:*AccessKey*",
        "iam:*SSHPublicKey*"
      ],
      "Resource": "arn:aws:iam::${var.aws_account}:user${var.user_path}${var.user_name}"
    },
    {
      "Sid": "AllowViewingOfProfiles",
      "Effect": "Allow",
      "Action": [
        "iam:ListAccount*",
        "iam:GetAccountSummary",
        "iam:GetAccountPasswordPolicy",
        "iam:ListUsers"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowUsersToCreateEnableResyncTheirOwnVirtualMFADevice",
      "Effect": "Allow",
      "Action": [
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice",
        "iam:ResyncMFADevice",
        "iam:DeactivateMFADevice",
        "iam:DeleteVirtualMFADevice"
      ],
      "Resource": [
        "arn:aws:iam::${var.aws_account}:mfa/${var.user_name}",
        "arn:aws:iam::${var.aws_account}:user${var.user_path}${var.user_name}"
      ]
    },
    {
      "Sid": "AllowUsersToListMFADevicesandUsersForConsole",
      "Effect": "Allow",
      "Action": [
        "iam:ListMFADevices",
        "iam:ListVirtualMFADevices",
        "iam:ListUsers"
      ],
      "Resource": [
                "arn:aws:iam::${var.aws_account}:mfa/*",
                "arn:aws:iam::${var.aws_account}:user${var.user_path}${var.user_name}"
            ]
    }
  ]
}
POLICY
}
