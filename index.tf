terraform {
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "VargasArts"
        workspaces {
            prefix = "static-site-demo"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

module "aws_static_site" {
    source  = "dvargas92495/static-site/aws"
    version = "1.2.0"

    domain = "static-site-demo.davidvargas.me"
    secret = "secret-key"
    tags = {
        Application = "static-site-demo"
    }
}

provider "github" {
    owner = "dvargas92495"
}

resource "github_actions_secret" "deploy_aws_access_key" {
  repository       = "static-site-demo"
  secret_name      = "DEPLOY_AWS_ACCESS_KEY_ID"
  plaintext_value  = module.aws_static_site.deploy-id     
}

resource "github_actions_secret" "deploy_aws_access_secret" {
  repository       = "static-site-demo"
  secret_name      = "DEPLOY_AWS_SECRET_ACCESS_KEY"       
  plaintext_value  = module.aws_static_site.deploy-secret 
}
