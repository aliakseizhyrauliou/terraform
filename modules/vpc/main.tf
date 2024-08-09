data "aws_availability_zones" "available" {
   state = "available"
}


//сеть
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  
  tags = {
    Name = var.vpc_name
  }
}

//публичная подсеть
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_name
  }
}

//приватная подсеть
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.private_subnet_name
  }
}

//приватная подсеть
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.private_subnet_name
  }
}


//шлюз для доступа в сеть
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

//Значит в этой сети будет доступ в интернет, который нужно прокинуть на подсеть
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id 
  }

  tags = {
    Name = var.aws_route_table_name
  }
}


//Привязывам правило на публичную подсеть
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


