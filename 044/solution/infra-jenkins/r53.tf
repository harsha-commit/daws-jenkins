module "jenkins_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = "harshadevops.site"

  records = [
    {
      name = "jenkins"
      type = "A"
      ttl  = 1
      records = [
        module.jenkins_master.public_ip
      ]
    },
    {
      name = "jenkins-agent"
      type = "A"
      ttl  = 1
      records = [
        module.jenkins_agent.public_ip
      ]
    },
  ]

}
