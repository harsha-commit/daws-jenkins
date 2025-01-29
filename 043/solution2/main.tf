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

module "jenkins_agent" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name      = "jenkins-agent"
  user_data = file("agent.sh")
  ami       = "ami-09c813fb71547fc4f"

  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-08ab8575176da550c"]
  subnet_id              = "subnet-0f87134601ecece2c"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "null_resource" "this" {
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
