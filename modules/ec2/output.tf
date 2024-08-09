output "instance_ids" {
  value = aws_instance.web[*].id
}

output "public_ips" {
  value = aws_instance.web[*].public_ip
}

output "selected_ami_id" {
  value = data.aws_ami.ubuntu.id
}