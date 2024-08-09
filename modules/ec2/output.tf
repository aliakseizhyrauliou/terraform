output "selected_ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "instance_site1_id" {
  value = aws_instance.site1.id
}

output "instance_site2_id" {
  value = aws_instance.site2.id
}