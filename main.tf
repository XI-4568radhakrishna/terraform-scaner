provider "aws" {
  region = "us-east-1" # Change to your preferred AWS region
}

##create VPC 
data "aws_vpc" "sdlc_vpc" {
  id = var.vpc_id # Replace with your existing VPC ID
  tags = {
    Name = "sdlc-vpc"
  }
}


##Create subnet
data "aws_subnet" "sdlc_subnet" {
  id = "subnet-87654321" # Replace with your actual Subnet ID
  tags = {
    Name = "sdlc-subnet"
  }
}

##Create a new security group in the existing VPC
resource "aws_security_group" "sdlc_sg" {
  name        = "sdlc-security-group"
  description = "Allow SSH and HTTP"
  vpc_id      = var.vpc_id

  # Inbound Rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (change for security)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  ##Outbound Rules (Allow all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-security-group"
  }
}

##Create Internet Gateway
resource "aws_internet_gateway" "sdlc_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "sdlc-InternetGateway"
  }
}

##Create Route Table for Public Subnet
resource "aws_route_table" "sdlc_public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sdlc_igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

## Associate Route Table with Existing Subnet
resource "aws_route_table_association" "sdlc_subnet_association" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.sdlc_public_rt.id
}

## Update Security Group Rules (Example: Allow Incoming Traffic on Port 80)
resource "aws_security_group_rule" "allow_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.sdlc_sg.id
}

# creating IAM roles and attaching to EC2 instance
resource "aws_instance" "aisdlc_instance" {
  ami                  = var.ami # Amazon Linux 2 AMI
  instance_type        = var.instance_type
  cpu_core_count       = var.cpu_core_count
  cpu_threads_per_core = var.cpu_threads_per_core
  availability_zone    = var.availability_zone
  subnet_id            = var.subnet_id
  security_groups      = [aws_security_group.sdlc_sg.name]
  key_name             = var.key_name
  get_password_data           = var.get_password_data
  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ip


  /*create_iam_instance_profile = true
  
  iam_role_policies = {
    AmazonElasticContainer = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
    AmazonElasticContainer = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
    AmazonElasticContainer = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    
  }

  tags = {
    Name = "sdlc-EC2Instance"
  }*/
}


# Generate an SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

##Save the private key locally
resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/terraform-key.pem"
}

resource "aws_ec2_instance_metadata_defaults" "enforce-imdsv2" {
  http_tokens                 = "required"
  http_put_response_hop_limit = 2
}

##Create an ECR Repository
resource "aws_ecr_repository" "sdlc_repo" {
  name = "sdlc-ecr-repo" # Change to your repository name

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "sdlc-ecr-repo"
  }
}


/*##Create a DynamoDB Table for State Locking (Optional but Recommended)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform Locks"
  }
}*/


##create S3 bucket
resource "aws_s3_bucket" "sdlc_terraform_state" {
  bucket = "sdlc-terraform-state-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Terraform State Bucket"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.sdlc_terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.sdlc_terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}



## Create EKS cluster 

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "sdlc_eks_cluster" {
  name     = "sdlc-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = ["subnet-0ea8c55669718e445", "subnet-0a4acccf6950db1c5"] # Replace with your subnet IDs
  }
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

/*resource "aws_iam_role_policy_attachment" "eks_full_policy" {
  role       = aws_iam_role.eks_full_role.name
  policy_arn = "arn:aws:iam::864899865567:role/AI-SDLC-ecs-access-role"
}*/
resource "aws_iam_role_policy_attachment" "ec2_container_registry_readonly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.sdlc_eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = ["subnet-0ea8c55669718e445"] # Replace with your subnet IDs

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.large"]
}


