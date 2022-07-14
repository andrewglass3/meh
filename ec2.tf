resource "aws_instance" "web" {
  ami           = "ami-0fb391cce7a602d1f"
  instance_type = "t3.micro"
  subnet_id        = aws_subnet.subnetmeh.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = "wireguard_april2022"

  tags = {
    Name = "MehItAllSucks"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.web.id
}

resource "aws_eip" "web" {
  vpc = true
}

# Create a VPC
resource "aws_vpc" "meh" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpcMeh"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.meh.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "subnetmeh" {
  vpc_id            = aws_vpc.meh.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "eu-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "tf-example"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.meh.id

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}