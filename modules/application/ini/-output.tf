output "ini_kms_key_arn" {
  value = "${aws_kms_key.ini.arn}"
}

output "ini_kms_key_id" {
  value = "${aws_kms_key.ini.id}"
}