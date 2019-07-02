output "bastion_autoscaling_group_name" {
  value = "${aws_autoscaling_group.bastion.name}"
}