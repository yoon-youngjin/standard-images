packer {
  required_plugins {
    amazon = {
      version = ">= 1.4.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "standard-ami" {
  region                      = "ap-northeast-2"
  instance_type               = "t2.micro" # 빌드 과정에서 packer가 임시로 띄울 EC2 인스턴스 타입
  subnet_id                   = "subnet-0a78cd8e358be88b4"
  associate_public_ip_address = true
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
  ami_name     = "standard-ami-{{timestamp}}"
  ami_regions  = ["ap-northeast-2"]

  tags = {
    Name        = "standard-ami"
    Environment = "dev"
  }
}

build {
  sources = ["source.amazon-ebs.standard-ami"]

  provisioner "shell" {
    script = "./ami/scripts/init.sh"
  }
}