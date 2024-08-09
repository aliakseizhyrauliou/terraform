variable "instance_count" {
  type = number
  default = 1
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "user_data" {
  type = string
  default = <<-EOF
    #!/bin/bash
    apt install nginx
  EOF
}

variable "virtualization_types" {
  type = list(string)
  default = ["hvm"]
}

variable "owners" {
  type = list(string)
  default = ["099720109477"]
}

variable "amis" {
  type = list(string)
  default = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
}

variable "key_name" {
    type = string
}