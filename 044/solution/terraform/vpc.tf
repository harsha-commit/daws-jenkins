module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  cidr   = "10.0.0.0/16"

  azs             = ["us-west-1a", "us-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "expense-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
}
