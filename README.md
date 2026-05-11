# GitOps AWS Infrastructure Pipeline

A production-grade GitOps CI/CD pipeline built on AWS using Terraform, GitHub Actions, OPA/Conftest, and Slack notifications — deployed across three isolated environments: **dev**, **staging**, and **prod**.

---

## 🏗️ Architecture Overview

```
Developer → PR to dev branch
              ↓
        Dev Environment (auto-deploy)
              ↓
        Merge to main
              ↓
        Staging Environment (auto-deploy)
              ↓
        Manual Approval Gate ← Human must approve
              ↓
        Prod Environment (deploy after approval)
              ↓
        Slack Notification (success or failure)
```

---

## 🚀 Features

- **GitOps Workflow** — PRs to `dev` auto-deploy to dev. Merges to `main` auto-deploy to staging. Prod requires manual approval.
- **Manual Approval Gate** — Production deployments are protected by a GitHub Environment approval gate. No code reaches prod without a human signing off.
- **OPA/Conftest Policy Checks** — Terraform plans are scanned before every apply. Deployments are blocked if resources violate security policies.
- **AWS Config Tagging Rules** — All AWS resources are continuously monitored for required tags (`Environment`, `Project`, `Owner`). Non-compliant resources are flagged automatically.
- **Remote State Management** — Terraform state is stored remotely in S3 with DynamoDB locking per environment, preventing state corruption and conflicts.
- **Slack Notifications** — Pipeline success and failure notifications are sent to a dedicated Slack channel in real time.

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| AWS | Cloud Provider |
| GitHub Actions | CI/CD Pipeline |
| OPA/Conftest | Policy as Code (DevSecOps) |
| AWS Config | Continuous Compliance Monitoring |
| S3 + DynamoDB | Remote Terraform State & Locking |
| Slack Webhooks | Pipeline Notifications |

---

## 📁 Repository Structure

```
gitops-aws-infra/
├── .github/
│   └── workflows/
│       ├── dev.yml          # Triggers on push/PR to dev branch
│       ├── staging.yml      # Triggers on merge to main
│       └── prod.yml         # Triggers on merge to main (with approval gate)
├── environments/
│   ├── dev/                 # Dev environment Terraform config
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── staging/             # Staging environment Terraform config
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── prod/                # Prod environment Terraform config
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── modules/
│   ├── vpc/                 # Reusable VPC module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── aws-config/          # Reusable AWS Config tagging rule module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── policies/
│   └── opa/                 # OPA/Conftest policy files
│       ├── tagging.rego         # Enforces required tags on all resources
│       ├── s3.rego              # Blocks public S3 buckets
│       └── security_groups.rego # Blocks SSH/RDP open to the world
└── README.md
```

---

## 🔐 OPA/Conftest Policies

Policies are written in Rego and run against the Terraform plan JSON before every apply. The pipeline **blocks** if any policy fails.

| Policy | What it enforces |
|---|---|
| `tagging.rego` | All resources must have `Environment`, `Project`, and `Owner` tags |
| `s3.rego` | No S3 buckets can have public ACLs or missing public access blocks |
| `security_groups.rego` | No security groups can open SSH (port 22) or RDP (port 3389) to 0.0.0.0/0 |

---

## 🌍 Environments

| Environment | Branch | Deployment | Approval Required |
|---|---|---|---|
| dev | `dev` | Auto on push | ❌ No |
| staging | `main` | Auto on merge | ❌ No |
| prod | `main` | After staging | ✅ Yes |

---

## ⚙️ GitHub Secrets Required

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS IAM access key |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM secret key |
| `AWS_REGION` | AWS region (e.g. `us-east-1`) |
| `TF_STATE_BUCKET` | S3 bucket name for Terraform state |
| `TF_LOCK_TABLE` | DynamoDB table name for state locking |
| `SLACK_WEBHOOK_URL` | Slack incoming webhook URL |

---

## 🏃 How to Use

### Prerequisites
- AWS CLI configured with appropriate IAM permissions
- Terraform >= 1.10.0
- GitHub account with Actions enabled

### Deploying to Dev
```bash
git checkout dev
# make your changes
git add .
git commit -m "feat: your change"
git push origin dev
# Pipeline triggers automatically
```

### Deploying to Staging & Prod
```bash
git checkout main
git merge dev
git push origin main
# Staging deploys automatically
# Prod waits for manual approval in GitHub Actions
```

---

## 📊 Pipeline Flow

```
Push to dev
    │
    ├── Terraform Init
    ├── Terraform Format Check
    ├── Terraform Validate
    ├── Terraform Plan
    ├── OPA/Conftest Policy Check ← blocks here if policies fail
    └── Terraform Apply (dev)
         └── Slack Notification ✅ or ❌

Merge to main
    │
    ├── Staging Job
    │   ├── Terraform Init → Validate → Plan
    │   ├── OPA/Conftest Policy Check
    │   ├── Terraform Apply (staging)
    │   └── Slack Notification ✅ or ❌
    │
    └── Prod Job (needs staging + manual approval)
        ├── ⏳ Awaiting Prod Approval
        ├── Terraform Init → Validate → Plan
        ├── OPA/Conftest Policy Check
        ├── Terraform Apply (prod)
        └── Slack Notification ✅ or ❌
```

---

## 👤 Author

**NkagisangCloud**
- GitHub: [@NkagisangCloud](https://github.com/NkagisangCloud)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
This project is open source and available under the [MIT License](LICENSE).
