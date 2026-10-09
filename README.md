# CloudGoat: EC2 SSRF

[CloudGoat](https://github.com/RhinoSecurityLabs/cloudgoat) by Rhino Security Labs: "vulnerable by
design" AWS deployment scenarios. This repository runs its `ec2_ssrf` scenario with
[Isoloom](https://www.isoloom.com) in your own AWS account: [`isoloom.yml`](isoloom.yml) describes
the cloud services, the scenario sits unchanged in
[`app/`](app), and [`terraform/`](terraform) is a small wrapper that
feeds the scenario what CloudGoat's Python CLI would.

| Cloud services | What |
| --- | --- |
| IAM | The users Solus, Wrex and Shepard |
| Lambda | A function with hardcoded secrets |
| EC2 | A web application vulnerable to SSRF |
| S3 | A private bucket |

Cost while it runs: one t3.micro EC2 instance and its public IPv4 address (about $0.02 an hour), a Lambda function, an S3 bucket.

## Run it

Use an AWS account with nothing else in it, signed in with the AWS CLI (`aws login`, the
`default` profile, or set another with `-s cloud.vars.profile=<name>`), and Terraform installed.

```bash
isoloom run cloud-services -s cloud.vars.whitelist=$(curl -s https://checkip.amazonaws.com)/32
isoloom test cloud-services
isoloom down cloud-services
```

The scenario's instances accept only your public IP: pass it on `run` (the spec holds a
placeholder that refuses to deploy). `down` works without it.

`run` prints where to start (your starting credentials, if the scenario gives you some). Guide:
the scenario's [README](app/cloudgoat/scenarios/aws/ec2_ssrf/README.md) and cheat sheets in [`app/cloudgoat/scenarios/aws/ec2_ssrf/`](app/cloudgoat/scenarios/aws/ec2_ssrf).
Anything you create yourself while playing isn't Terraform's: delete it before `down`.

Upstream version and commit: [UPSTREAM.md](UPSTREAM.md).

## Licence

BSD-3-Clause, as CloudGoat ([LICENSE](LICENSE)). This lab is deliberately vulnerable: deploy it
only in an account you use for nothing else, and destroy it when you are done.
