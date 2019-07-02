
module "ryan_mcmichael" {
  source = "../../modules/users/user"
  aws_account = "${var.aws_account_id}"
  user_name = "ryan"
  user_path = "/"
}

resource "aws_iam_group_membership" "admins" {
  name = "aws-admins-group-membership"
  users = [
    "${module.ryan_mcmichael.user_name}"
  ]
  group = "${aws_iam_group.admins.name}"
}

resource "aws_iam_group_membership" "s3_admins" {
  name = "s3-admins-group-membership"
  users = [
    "${module.ryan_mcmichael.user_name}"
  ]
  group = "${aws_iam_group.s3_admins.name}"
}
