variable "vpc_id" {
  type = string
}

variable "lb_name" {
  type = string
  default = "mylb"
}

variable "security_groups" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}


variable "site1" {
  type = string
}

variable "site2" {
  type = string
}