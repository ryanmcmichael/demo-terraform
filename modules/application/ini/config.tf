resource "aws_kms_key" "ini" {
  description         = "ini key for ${var.environment}"
  enable_key_rotation = true
}
/*
resource "aws_kms_alias" "ini" {
  name          = "alias/${var.environment}-ini"
  target_key_id = "${aws_kms_key.ini.key_id}"
}
*/
