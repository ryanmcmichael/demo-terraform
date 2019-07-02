resource "aws_rds_cluster" "demo" {
  cluster_identifier              = "demo"
  database_name                   = "${var.demo_db_name}"
  master_password                 = "${var.demo_db_password}"
  master_username                 = "${var.demo_db_username}"
  vpc_security_group_ids          = ["${var.db_security_group_id}"]
  storage_encrypted               = true
  db_subnet_group_name            = "${var.db_subnet_group_name}"
  kms_key_id                      = "${var.kms_key_arn}"
  iam_roles                       = ["${var.demo_rds_role_arn}"]
  iam_database_authentication_enabled = false
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "demo-${count.index}"
  cluster_identifier = "${aws_rds_cluster.demo.id}"
  instance_class     = "db.t2.medium"
}