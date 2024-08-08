terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.61.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

module "vpc" {
  source = "./modules/vpc"

  //vpc
  cidr_block = "10.0.0.0/16"
  vpc_name = "my_vpc"

  //public subnet
  public_subnet_cidr = "10.0.1.0/24"
  public_subnet_name = "my_public_subnet"

  //private subnet
  private_subnet_cidr = "10.0.2.0/24"
  private_subnet_name = "my_private_subnet"

  //subnet common
  availability_zone = "us-east-1a"

  
  aws_route_table_name = "private_route_table"
}




