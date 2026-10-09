# Upstream

| | |
| --- | --- |
| Project | CloudGoat (scenario `ec2_ssrf`) |
| Repository | https://github.com/RhinoSecurityLabs/cloudgoat |
| Version | v2.5.0 |
| Commit | abf1ba8f5e47d7ced750fdfa025d51c99f1a43ed |
| Licence | BSD-3-Clause |

`app/` holds, from that commit and at their upstream paths, unchanged: CloudGoat's `LICENSE`,
`README.md` and the scenario folder `cloudgoat/scenarios/aws/ec2_ssrf/`. The rest of CloudGoat (its
Python CLI and the other scenarios) is left out: the lab doesn't use it, and two other scenarios'
cheat sheets hold example AWS keys that GitHub's push protection refuses.

`terraform/main.tf` is this lab's own wrapper root
module: it applies the scenario's `terraform/` folder as a child module with the variables
CloudGoat's Python CLI would pass (a random `cgid`, the AWS profile, the player's IP as the
`cg_whitelist` list), and an SSH key pair made by `terraform/keygen.sh`. The
scenario reads some files relative to Terraform's working directory, so `assets` is a symlink to
the scenario's `assets/`. To update, take those paths from a newer release and change this table.
