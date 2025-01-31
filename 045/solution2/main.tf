module "jenkins_master" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-master"
  ami  = "ami-09c813fb71547fc4f"

  instance_type          = "t2.small"
  vpc_security_group_ids = ["sg-08ab8575176da550c"]
  subnet_id              = "subnet-0f87134601ecece2c"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "jenkins_master_records" {
  source    = "terraform-aws-modules/route53/aws//modules/records"
  version   = "~> 3.0"
  zone_name = var.zone_name

  records = [
    {
      name = "jenkins"
      type = "A"
      ttl  = 1
      records = [
        module.jenkins_master.public_ip
      ]
    },
  ]
}

module "jenkins_agent" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name      = "jenkins-agent"
  user_data = file("agent.sh")
  ami       = "ami-09c813fb71547fc4f"

  instance_type          = "t2.medium"
  vpc_security_group_ids = ["sg-08ab8575176da550c"]
  subnet_id              = "subnet-0f87134601ecece2c"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "jenkins_agent_records" {
  source    = "terraform-aws-modules/route53/aws//modules/records"
  version   = "~> 3.0"
  zone_name = var.zone_name

  records = [
    {
      name = "jenkins-agent"
      type = "A"
      ttl  = 1
      records = [
        module.jenkins_agent.private_ip
      ]
    },
  ]
}

resource "null_resource" "jenkins_master" {
  triggers = {
    instance_id = module.jenkins_master.id
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = module.jenkins_master.public_ip
  }

  provisioner "file" {
    source      = "jenkins.repo"
    destination = "/tmp/jenkins.repo"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/jenkins.repo /etc/yum.repos.d/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",
      "sudo yum install fontconfig java-17-openjdk -y",
      "sudo yum install jenkins -y",
      "sudo systemctl daemon-reload",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins"
    ]
  }
}

resource "aws_key_pair" "nexus" {
  key_name   = "nexus-key-pair"
  public_key = file("~/.ssh/tools.pub")
}

module "nexus" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name     = "nexus"
  ami      = "ami-060acff96b33652b7"
  key_name = aws_key_pair.nexus.key_name

  instance_type          = "t3.medium"
  vpc_security_group_ids = ["sg-08ab8575176da550c"]
  subnet_id              = "subnet-0f87134601ecece2c"

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 30
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "nexus_records" {
  source    = "terraform-aws-modules/route53/aws//modules/records"
  version   = "~> 3.0"
  zone_name = var.zone_name

  records = [
    {
      name = "nexus"
      type = "A"
      ttl  = 1
      records = [
        module.nexus.public_ip
      ]
    },
  ]
}
