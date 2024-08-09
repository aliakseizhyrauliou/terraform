data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = var.amis
  }

  filter {
    name   = "virtualization-type"
    values = var.virtualization_types
  }

  owners = var.owners
}


resource "aws_instance" "web" {
  count            = var.instance_count
  ami              = data.aws_ami.ubuntu.id
  instance_type    = var.instance_type
  subnet_id        = var.subnet_id
  security_groups  = var.security_groups

  key_name = var.key_name
  associate_public_ip_address = true

  user_data = var.user_data
}

resource "aws_eip" "one" {
  for_each = { for idx, instance in aws_instance.web : idx => instance }

  instance = each.value.id
}
