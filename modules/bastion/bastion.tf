resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  key_name               = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }

  provisioner "file" {
    source      = "bastion_config.sh"
    destination = "/tmp/bastion_config.sh"
    connection {
        host = aws_instance.bastion.public_ip
      type     = "ssh"
      user     = "ec2-user"
      private_key = file(var.ssh_private_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bastion_config.sh",
      "/tmp/bastion_config.sh"
    ]
    connection {
        host = aws_instance.bastion.public_ip
      type     = "ssh"
      user     = "ec2-user"
      private_key = file(var.ssh_private_key)
    }
  }
}

# Security group for bastion host to allow SSH access
resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow SSH from anywhere"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to your own IP range for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "ami_id" {
  description = "The AMI ID to be used for the bastion host"
}

variable "instance_type" {
  description = "The instance type for the bastion host"
}

variable "public_subnet_id" {
  description = "The public subnet ID for the bastion host"
}

variable "key_name" {
  description = "The SSH key name for the bastion host"
}

variable "ssh_private_key" {
  description = "Path to your private SSH key"
}
