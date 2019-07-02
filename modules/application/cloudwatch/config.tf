resource "aws_cloudwatch_metric_alarm" "NumberOfNotificationsFailedTooHighAlarm" {
  alarm_name                = "NumberOfNotificationsFailedTooHighAlarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "NumberOfNotificationsFailed"
  namespace                 = "AWS/SNS"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = "0"
  alarm_description         = "Alerts could not be delivered"
  alarm_actions             = ["${var.fallback_topic_arn}"]
}

resource "aws_cloudwatch_metric_alarm" "BastionCPUTooHighAlarm" {
  alarm_name                = "BastionCPUTooHighAlarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "600"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "Average Bastion CPU utilization over last 10 minutes higher than 80%"
  alarm_actions             = ["${var.topic_arn}"]

  dimensions {
    AutoScalingGroupName = "${var.bastion_autoscaling_group_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarmDemoApiSlow" {
  alarm_name                = "alarmDemoApiSlow"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Latency"
  namespace                 = "AWS/ApiGateway"
  period                    = "60"
  statistic                 = "SampleCount"
  threshold                 = "10000"
  alarm_description         = "Greater latency for live api gateway"
  alarm_actions             = ["${var.application-errors_arn}"]

  dimensions {
    ApiName = "${var.demo_api_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarmDemoGatewayLatency" {
  alarm_name                = "alarmDemoGatewayLatency"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Latency"
  namespace                 = "AWS/ApiGateway"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "10000"
  alarm_description         = "Gateway latency is high"
  alarm_actions             = ["${var.application-errors_arn}"]

  dimensions {
    ApiName = "${var.demo_api_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarmDemoLiveApiCalls" {
  alarm_name                = "alarmDemoLiveApiCalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Count"
  namespace                 = "AWS/ApiGateway"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = "500"
  alarm_description         = "Too many api calls"
  alarm_actions             = ["${var.application-errors_arn}"]

  dimensions {
    ApiName = "${var.demo_api_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarmDemoLiveFunctionUserLogin" {
  alarm_name                = "alarmDemoLiveFunctionUserLogin"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Count"
  namespace                 = "AWS/Lambda"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "10"
  alarm_description         = "Too many invocations of user login function"
  alarm_actions             = ["${var.application-errors_arn}"]

  dimensions {
    FunctionName = "${var.user_login_lambda_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarmDemoLiveFunctionUserRegister" {
  alarm_name                = "alarmDemoLiveFunctionUserRegister"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Invocations"
  namespace                 = "AWS/Lambda"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "10"
  alarm_description         = "Too many invocations of user registration"
  alarm_actions             = ["${var.application-errors_arn}"]

  dimensions {
    FunctionName = "${var.user_register_lambda_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarmDemoLiveSnsFormSubmission" {
  alarm_name                = "alarmDemoLiveSnsFormSubmission"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "NumberOfNotificationsFailed"
  namespace                 = "AWS/SNS"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Form submission sns failed."
  alarm_actions             = ["${var.application-errors_arn}"]

  dimensions {
    TopicName = "${var.ch_form_submission_lambda_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarmDemoLiveRDSBlockedTx" {
  alarm_name                = "alarmDemoLiveRDSBlockedTx"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "BlockedTransactions"
  namespace                 = "AWS/RDS"
  period                    = "300"
  statistic                 = "SampleCount"
  threshold                 = "1"
  alarm_description         = "Transactions blocked in Demo live rds."
  alarm_actions             = ["${var.application-errors_arn}"]

  dimensions {
    DBInstanceIdentifier = "${var.prod_demo_db_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarmlive5xxerror" {
  alarm_name                = "alarmlive5xxerror"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "5XXError"
  namespace                 = "AWS/ApiGateway"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "Demo live 5xx error"
  alarm_actions             = ["${var.application-errors_arn}"]

  dimensions {
    ApiName = "${var.demo_api_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarmliveblockedtxs" {
  alarm_name                = "alarmliveblockedtxs"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "BlockedTransactions"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "Demo Live Tx blocked"
  alarm_actions             = ["${var.application-errors_arn}"]

  dimensions {
    DBInstanceIdentifier = "${var.prod_demo_db_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarmlivedlq" {
  alarm_name                = "alarmlivedlq"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "ApproximateNumberOfMessagesVisible"
  namespace                 = "AWS/SQS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "Demo Live dlq"
  alarm_actions             = ["${var.application-errors_arn}"]

  dimensions {
    QueueName = "${var.fallback_dlq_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarmliverdshighcpu" {
  alarm_name                = "alarmliverdshighcpu"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "75"
  alarm_description         = "Demo Live high RDS CPU"
  alarm_actions             = ["${var.application-errors_arn}"]

  dimensions {
    QueueName = "${var.prod_demo_db_name}"
  }
}

