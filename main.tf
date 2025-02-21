provider "aws" {
  region = "us-east-1" # Change to your preferred AWS region
}

module ec2{
  source = "../.."
}

module IAM {
  source = "../.."
}

# Data block to fetch existing VPC and Subnets
data "aws_vpc" "sdlc_vpc" {
  id = var.vpc_id  # Replace with your VPC ID
}

data "aws_subnets" "sdlc_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.sdlc_vpc.id]
  }
}


/*resource "aws_instance" "AI_Instance_04" {
  ami           = var.ami# Amazon Linux 2 AMI (Change based on region)
  instance_type = var.instance_type

  tags = {
    Name = "AI-Instance-SDLC-4"
  }
}*/


# create VPC 

/*resource "aws_vpc" "sdlc_vpc" {
  cidr_block = var.vpc_id
  
  tags = {
    Name = "sdlc_vpc"
  }
}*/


## Create subnet

/*resource "aws_subnet" "sdlc_subnet" {
  vpc_id            = aws_vpc.sdlc_vpc.id
  cidr_block        = var.subnet_cidr_block
  map_public_ip_on_launch = true  # Assign public IP automatically
  availability_zone = var.availability_zone

  tags = {
    Name = "sdlc_subnet"
  }
}*/


## Create an Internet Gateway

resource "aws_internet_gateway" "sdlc_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "sdlc_igw"
  }
}


## Create Route Table

resource "aws_route_table" "sdlc_route_table" {
  vpc_id = data.aws_vpc.sdlc_vpc.id

  route {
    cidr_block = var.cidr_block  # Allow all outbound traffic
    gateway_id = aws_internet_gateway.sdlc_igw.id
  }

  tags = {
    Name = "sdlc_RouteTable"
  }
}



## Define Route Table & Attach It to the Subnet

resource "aws_route_table" "sdlc_subnet_route_table" {
  vpc_id = data.aws_vpc.sdlc_vpc.id

  route {
    cidr_block = var.cidr_block  # Allow all outbound traffic
    gateway_id = aws_internet_gateway.sdlc_igw.id
  }

  tags = {
    Name = "sdlc_RouteTable"
  }
}

resource "aws_route_table_association" "sdlc_rta" {
  subnet_id      = data.aws_subnets.sdlc_subnet.id
  route_table_id = aws_route_table.sdlc_route_table.id
}


## Create a Security Group


resource "aws_security_group" "sdlc_sg" {
  vpc_id = data.aws_vpc.sdlc_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic
  }
  
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "sdlc_SecurityGroup"
  }
}



### Launch EC2 Instance in Subnet


/*resource "aws_instance" "sdlc_instance" {
  ami             = "ami-04e914639d0cca79a"  # Amazon Linux 2 AMI
  instance_type   = "t2.large"
  subnet_id       = aws_subnet.sdlc_subnet.id
  security_groups = [aws_security_group.sdlc_sg.name]

  tags = {
    Name = "sdlc-EC2Instance"
  }
}*/
