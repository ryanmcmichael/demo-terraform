resource "aws_lambda_function" "demo-form-submission-api" {
  description      = "Operations involving Demo Form Submission."
  s3_bucket        = "${var.lambda_functions_bucket}"
  s3_key           = "${var.placeholder_package}"
  function_name    = "demo-form-submission-api"
  role             = "${var.lambda_common_role_arn}"
  handler          = "demo-form-submission-api.handler"
  runtime          = "nodejs6.10"
  timeout          = 15
  memory_size      = 256
  kms_key_arn      = "${var.kms_key_arn}"
  publish          = true

  vpc_config {
    subnet_ids = ["${var.services_subnet_ids}"]
    security_group_ids = ["${var.lambda_security_group_id}"]
  }

  dead_letter_config {
    target_arn = "${var.dlq_arn}"
  }

  environment = {
    variables = {
      SenderID_input_xml = "${var.demo_input_user}"
      Password_input_xml = "${var.demo_input_password}"
      GatewayTest = "${var.demo-gateway-test}"
      ch_url = "${var.demo_url}"
    }
  }

}

resource "aws_lambda_permission" "ch-form-submission-api-sns" {
  statement_id = "ch-form-submission-api-sns"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ch-form-submission-api.arn}"
  principal = "sns.amazonaws.com"
  source_arn = "${var.ch_form_submission_arn}"
}