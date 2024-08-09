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


resource "aws_instance" "site1" {
  ami              = data.aws_ami.ubuntu.id
  instance_type    = var.instance_type
  subnet_id        = var.subnet_id
  security_groups  = var.security_groups

  key_name = var.key_name
  associate_public_ip_address = true

  user_data = var.user_data_site1
}

resource "aws_instance" "site2" {
  ami              = data.aws_ami.ubuntu.id
  instance_type    = var.instance_type
  subnet_id        = var.subnet_id
  security_groups  = var.security_groups

  key_name = var.key_name
  associate_public_ip_address = true

  user_data = var.user_data_site2
}

resource "aws_eip" "one" {
  instance = aws_instance.site1.id
}

resource "aws_eip" "two" {
  instance = aws_instance.site2.id
}

