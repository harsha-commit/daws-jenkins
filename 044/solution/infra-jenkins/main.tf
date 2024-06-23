module "jenkins_master" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami           = "ami-031d574cddc5bb371"
  instance_type = "t3.small"

  vpc_security_group_ids = ["sg-08ab8575176da550c"]
  user_data              = file("jenkins.sh")

  tags = {
    Name        = "jenkins-master"
    Terraform   = "true"
    Environment = "dev"
  }
}

module "jenkins_agent" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami           = "ami-031d574cddc5bb371"
  instance_type = "t2.small"

  vpc_security_group_ids = ["sg-08ab8575176da550c"]
  user_data              = file("jenkins-agent.sh")

  tags = {
    Name        = "jenkins-agent"
    Terraform   = "true"
    Environment = "dev"
  }
}
