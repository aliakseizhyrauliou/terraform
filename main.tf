terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.61.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
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
  availability_zone = "us-west-1b"

  
  aws_route_table_name = "private_route_table"
  
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "key_pair" {
  source = "./modules/key_pair"
}


module "ec2" {
  source = "./modules/ec2"

  instance_count = 2
  instance_type = "t3.micro"
  subnet_id = module.vpc.public_subnet_id
  security_groups = [module.sg.ec2_sg_id] 
  key_name = module.key_pair.key_pair_name
}


module "lb" {
  source = "./modules/alb"

  security_groups = [ module.sg.alb_sg_id ]
  subnets = [ module.vpc.private_subnet_id, module.vpc.public_subnet_id]
  vpc_id = module.vpc.vpc_id
  site1 = module.ec2.instance_site1_id
  site2 = module.ec2.instance_site2_id
}