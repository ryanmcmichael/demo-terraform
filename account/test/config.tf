provider "aws" {
  allowed_account_ids = ["${var.aws_account_id}"]
  access_key          = "${var.aws_access_key}"
  secret_key          = "${var.aws_secret_key}"
  region              = "${var.region}"
}

data "terraform_remote_state" "test" {
  backend   = "s3"
  config {
    bucket  = "demo-test-terraform"
    key     = "${var.region}/state.json"
    region  = "${var.region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
  }
}

#------------Set up the account-------------
module "account" {
  source                          = "../../modules/account"
  account                         = "${var.account}"
  aws_account_id                  = "${var.aws_account_id}"
  aws_access_key                  = "${var.aws_access_key}"
  aws_secret_key                  = "${var.aws_secret_key}"
  region                          = "${var.region}"
}

module "s3" {
  source                          = "../../modules/application/s3"
  account                         = "${var.account}"
  log_bucket_id                   = "${module.account.log_bucket_id}"
}


#-----------Prepare the network and VPC------------
module "network-variables" {
  environment                     = "${var.environment}"
  region                          = "${var.region}"
  source                          = "../../modules/network-variables"
}

module "vpc" {
  environment                     = "${var.environment}"
  environment_cidr_block          = "${module.network-variables.environment_cidr_block}"
  instance_tenancy                = "default"
  source                          = "../../modules/application/vpc"
}

module "network" {
  environment                     = "${var.environment}"
  region                          = "${var.region}"
  source                          = "../../modules/application/network"
  vpc_cidr_block                  = "${module.vpc.vpc_cidr_block}"
  vpc_default_network_acl_id      = "${module.vpc.vpc_default_network_acl_id}"
  vpc_id                          = "${module.vpc.vpc_id}"
  zone_count                      = "${length(split(",", var.zones))}"
  zones                           = "${var.zones}"
  bastion_whitelist_cidr_blocks   = "${var.bastion_whitelist_cidr_blocks}"
  whitelist_cidr_blocks           = "${var.whitelist_cidr_blocks}"
}


#------------Stand up the application components------------
module "iam" {
  aws_account_id                  = "${var.aws_account_id}"
  region                          = "${var.region}"
  environment                     = "${var.environment}"
  source                          = "../../modules/application/iam"
}

module "sqs" {
  environment                           = "${var.environment}"
  aws_account_id                        = "${var.aws_account_id}"
  region                                = "${var.region}"
  #cp_submit_application_lambda_arn = "${module.lambda.cp_submit_application_lambda_arn}"
  #ch_form_submission_lambda_arn    = "${module.lambda.ch_form_submission_lambda_arn}"
  source                                = "../../modules/application/sqs"
}

module "sns" {
  environment                             = "${var.environment}"
  aws_account_id                          = "${var.aws_account_id}"
  #live-ch-status-check_lambda_arn         = "${module.lambda.live-ch-status-check_lambda_arn}"
  #ch_form_submission_lambda_arn      = "${module.lambda.ch_form_submission_lambda_arn}"
  fallback_queue_arn                 = "${module.sqs.fallback_queue_arn}"
  #ch_get_document_lambda_arn         = "${module.lambda.ch_get_document_lambda_arn}"
  #ch_status_notify_lambda_arn        = "${module.lambda.ch_status_notify_lambda_arn}"
  #cp_submit_application_lambda_arn   = "${module.lambda.cp_submit_application_lambda_arn}"
  dlq_queue_arn                      = "${module.sqs.dlq_queue_arn}"
  #id_check_credits_verify_queue_arn  = "${module.lambda.id_check_credits_verify_queue_arn}"
  source                                  = "../../modules/application/sns"
}

module "ini" {
  environment                       = "${var.environment}"
  source                            = "../../modules/application/ini"
}

module "elb" {
  environment                       = "${var.environment}"
  bastion_elb_port                  = "${var.bastion_elb_port}"
  bastion_elb_security_group_id     = "${module.network.bastion_security_group_id}"
  log_bucket_id                     = "${module.account.log_bucket_id}"
  pub_subnet_ids                    = "${module.network.pub_subnet_ids}"
  source                            = "../../modules/application/elb"
}

module "bastion" {
  environment                       = "${var.environment}"
  region                            = "${var.region}"
  instance_key_name                 = "${module.account.instance_key_name}"
  instance_type                     = "${var.bastion_instance_type}"
  bastion_image_id                  = "${var.bastion_image_id}"
  config_bucket                     = "${module.s3.config_bucket}"
  ini_kms_key_arn                   = "${module.ini.ini_kms_key_arn}"
  mgt_subnet_ids                    = "${module.network.mgt_subnet_ids}"
  pub_subnet_ids                    = "${module.network.pub_subnet_ids}"
  security_group_ids                = "${module.network.bastion_security_group_id}"
  bastion_elb_name                  = "${module.elb.bastion_elb_name}"
  source                            = "../../modules/application/ec2/bastion"
}

module "api-gateway" {
  source                            = "../../modules/application/api-gateway"
}

module "cloudfront" {
  environment                       = "${var.environment}"
  log_bucket_id                     = "${module.account.log_bucket_id}"
  demo_api_name                     = "${module.api-gateway.demo_api_name}"
  domain_name                       = "${var.environment}-api.demo.com"
  source                            = "../../modules/application/cloudfront"
}

module "cloudwatch" {
  fallback_topic_arn                = "${module.sns.fallback_topic_arn}"
  topic_arn                         = "${module.sns.topic_arn}"
  bastion_autoscaling_group_name    = "${module.bastion.bastion_autoscaling_group_name}"
  application-errors_arn            = "${module.sns.application-errors_arn}"
  demo_api_name                 = "${module.api-gateway.demo_api_name}"
  #user_login_lambda_name       = "${module.lambda.user_login_lambda_name}"
  #user_register_lambda_name    = "${module.lambda.user_register_lambda_name}"
  fallback_dlq_name            = "${module.sqs.fallback_queue_arn}"
  prod_demo_db_name                 = "${var.demo_db_name}"
  #ch_form_submission_lambda_name = "${module.lambda.ch_form_submission_lambda_arn}"
  source                            = "../../modules/application/cloudwatch"
}

module "rds" {
  environment                       = "${var.environment}"
  demo_db_name                      = "${var.demo_db_name}"
  db_security_group_id              = "${module.network.database_security_group_id}"
  db_subnet_group_name              = "${module.network.database_subnet_group_name}"
  demo_db_password                  = "${var.demo_db_password}"
  demo_db_username                  = "${var.demo_db_username}"
  demo_rds_role_arn                 = "${module.iam.demo_rds_role_arn}"
  kms_key_arn                        = "${module.ini.ini_kms_key_arn}"
  zones                             = "${var.zones}"
  source                            = "../../modules/application/rds"
}

/*module "lambda" {
  environment                     = "${var.environment}"
  aws_account_id                  = "${var.aws_account_id}"
  lambda_functions_bucket         = "${module.s3.lambda_functions_bucket}"
  placeholder_package             = "${var.placeholder_package}"
  region                          = "${var.region}"
  services_subnet_ids             = ["${split(",", module.network.services_subnet_ids)}"]
  lambda_security_group_id        = "${module.network.lambda_security_group_id}"
  aws_account_id                  = "${var.aws_account_id}"
  account                         = "${var.account}"
  lambda_common_role_arn          = "${module.iam.lambda_common_role_arn}"
  kms_key_arn                     = "${module.ini.ini_kms_key_arn}"

  ch_form_submission_arn          = "${module.sns.ch_form_submission_arn}"
  cp_send_application_arn         = "${module.sns.cp_send_application_arn}"
  dlq_arn                         = "${module.sqs.dlq_queue_arn}"
  ch_status_check_arn             = "${module.sns.ch_status_check_arn}"
  ch_get_document_arn             = "${module.sns.ch_get_document_arn}"
  ch_status_notify_arn            = "${module.sns.ch_status_notify_arn}"
  id_check_credits_verify_arn     = "${module.sns.id_check_credits_verify_arn}"
  id_check_credits_notify_arn     = "${module.sns.id_check_credits_notify_arn}"

  ch_url                          = "${var.ch_url}"
  cashplus_token_url              = "${var.cashplus_token_url}"
  cashplus_industries_url         = "${var.cashplus_industries_url}"
  cashplus_products_url           = "${var.cashplus_products_url}"
  cashplus_application_status     = "${var.cashplus_application_status}"
  cashplus_application_clearinfo  = "${var.cashplus_application_clearinfo}"
  idcheck_url                     = "${var.idcheck_url}"
  idcheck_credits_url             = "${var.idcheck_credits_url}"
  cashplus_application_url        = "${var.cashplus_application_url}"
  fallback_sqs_url                = "${var.fallback_sqs_url}"
  cloudsearch_censor_names_search    = "${var.cloudsearch_censor_names_search}"

  ch-gateway-test                 = "${var.ch-gateway-test}"
  id-check_user                   = "${var.id-check_user}"
  id-check_password               = "${var.id-check_password}"
  ch_input_user                   = "${var.ch_input_user}"
  ch_input_password               = "${var.ch_input_password}"
  ch_output_user                  = "${var.ch_output_user}"
  ch_output_password              = "${var.ch_output_password}"
  cashplus_user                   = "${var.cashplus_user}"
  cashplus_password               = "${var.cashplus_password}"
  stripe_secret_key               = "${var.stripe_secret_key}"
  deploymentBucket_name           = "${var.deploymentBucket_name}"

  source                          = "../../modules/application/lambda"
}*/