# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"  # Specify the IP range for the VPC

  tags = {
    Name = "example-vpc"
  }
}

# Create a subnet in the VPC
resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id  # Reference the VPC ID
  cidr_block              = "10.0.0.0/24"  # Specify the IP range for the subnet
  availability_zone       = "us-east-1a"  # Specify the availability zone

  tags = {
    Name = "example-subnet"
  }
}

# Create a security group
resource "aws_security_group" "example_sg" {
  name        = "example-security-group"
  description = "Example security group"
  vpc_id      = aws_vpc.example_vpc.id  # Reference the VPC ID

  # Allow inbound traffic on port 80 (HTTP)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound traffic on port 22 (SSH) for administration (optional)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-security-group"
  }
}

# Create an EC2 instance with user data
resource "aws_instance" "example_instance" {
  ami                    = "ami-0889a44b331db0194"  # Amazon Linux 2 AMI ID
  instance_type          = "t2.micro"  # Specify the instance type
  subnet_id              = aws_subnet.example_subnet.id  # Reference the subnet ID
  vpc_security_group_ids = [aws_security_group.example_sg.id]  # Reference the security group ID
  key_name               = "KeyPair1"  # Specify the key pair for SSH access

  user_data = <<EOF
    #!/bin/bash
    echo "Hello, World!" > /var/www/html/index.html
    systemctl enable httpd
    systemctl start httpd
  EOF

  tags = {
    Name = "example-instance"
  }
}
