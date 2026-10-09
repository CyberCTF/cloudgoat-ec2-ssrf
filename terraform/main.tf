# Wrapper root module (this lab's own file, not upstream's): applies CloudGoat's ec2_ssrf scenario
# (app/cloudgoat/scenarios/aws/ec2_ssrf/terraform, unchanged) as a child module with the variables
# CloudGoat's Python CLI would pass: a cgid ("ec2_ssrf_cgid" and ten random characters, as
# CloudGoat makes it), the AWS profile, the player's public IP as cg_whitelist (a list, which
# Isoloom's string `vars` can't express) and an SSH key pair, made once by keygen.sh into the
# lab's .keys/ (CloudGoat's CLI runs ssh-keygen the same way). The scenario reads files relative
# to Terraform's working directory: this lab's `assets` is a symlink to the scenario's own.
terraform {
  required_version = ">= 1.5"
  required_providers {
    random   = { source = "hashicorp/random", version = "~> 3.6" }
    external = { source = "hashicorp/external", version = "~> 2.3" }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  description = "The AWS CLI profile the scenario's provider (and its deploy steps) use."
  type        = string
  default     = "default"
}

variable "whitelist" {
  description = "Your public IP as a CIDR (x.x.x.x/32): the only address the scenario's instances accept."
  type        = string
  default     = "0.0.0.0/32"
}

# Refuses to create the lab before the player set their IP (not checked on destroy, so
# `isoloom down` works whatever the value).
resource "terraform_data" "whitelist_set" {
  lifecycle {
    precondition {
      condition     = can(cidrhost(var.whitelist, 0)) && var.whitelist != "0.0.0.0/32"
      error_message = "Set your public IP: isoloom run cloud-services -s cloud.vars.whitelist=$(curl -s https://checkip.amazonaws.com)/32"
    }
  }
}

resource "random_string" "cgid" {
  length  = 10
  upper   = false
  special = false
}

data "external" "ssh_key" {
  program = ["sh", "${path.module}/keygen.sh", abspath("${path.module}/../.keys")]
}

module "scenario" {
  source          = "../app/cloudgoat/scenarios/aws/ec2_ssrf/terraform"
  profile         = var.profile
  region          = var.region
  cgid            = "ec2_ssrf_cgid${random_string.cgid.result}"
  cg_whitelist    = [var.whitelist]
  ssh_public_key  = data.external.ssh_key.result.public
  ssh_private_key = data.external.ssh_key.result.private
}

output "access_key_id" {
  value = module.scenario.cloudgoat_output_solus_access_key_id
}

output "secret_key" {
  value     = module.scenario.cloudgoat_output_solus_secret_key
  sensitive = true
}
