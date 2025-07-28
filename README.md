AWS Identity Center Terraform Project
This Terraform project automates the management of AWS IAM Identity Center (formerly AWS SSO) permission sets, user assignments, and access control across multiple AWS accounts.
📋 Table of Contents

Overview
Project Structure
Prerequisites
Quick Start
Configuration
Usage
File Descriptions
Adding New Resources
Best Practices
Troubleshooting

🎯 Overview
This project provides Infrastructure as Code (IaC) for managing:

Permission Sets: Role-based access templates with AWS managed and custom policies
User Assignments: Mapping users to permission sets across AWS accounts
External Policy Files: Modular inline policies stored as separate JSON files
Multi-Account Access: Centralized access management across AWS Organizations

📁 Project Structure
AWS Identity Center/
├── outfiles/                    # Terraform output files
├── terraform/                   # Main Terraform configuration
├── policies/                    # External policy JSON files
│   ├── developer-policy.json
│   ├── database-admin-policy.json
│   └── security-audit-policy.json
├── .gitignore                   # Git ignore rules
├── terraform.lock.hcl           # Provider lock file
├── data.tf                      # Data sources (users, groups, identity store)
├── locals.tf                    # Local values and computations
├── main.tf                      # Main resources (permission sets, assignments)
├── outputs.tf                   # Output values
├── terraform.tf                 # Provider and Terraform configuration
├── terraform.tfstate            # Terraform state file (local backend)
├── terraform.tfvars             # Variable values (main configuration)
├── variables.tf                 # Variable definitions
└── README.md                    # This file
🛠️ Prerequisites
Required Software

Terraform >= 1.0
AWS CLI >= 2.0
Git Bash or similar terminal (Windows)

AWS Requirements

AWS IAM Identity Center enabled in your AWS Organization
AWS SSO instance ARN (format: arn:aws:sso:::instance/ssoins-xxxxxxxxx)
Appropriate permissions for managing Identity Center resources:

sso:*
identitystore:*
organizations:DescribeOrganization



Authentication

AWS SSO profile configured: aws configure sso
Valid SSO session: aws sso login --profile your-profile-name

🚀 Quick Start
1. Clone and Setup
bashgit clone <repository-url>
cd "AWS Identity Center"
2. Configure AWS Authentication
bash# Configure SSO profile
aws configure sso

# Login to SSO
aws sso login --profile management
3. Customize Configuration
Edit terraform.tfvars with your specific values:

Update user email addresses
Modify account IDs
Adjust permission sets as needed

4. Initialize and Deploy
bash# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply changes
terraform apply
⚙️ Configuration
Primary Configuration File: terraform.tfvars
This file contains all your customizable settings:
hcl# Environment and region
environment = "management"
aws_region  = "us-east-1"

# AWS account mappings
target_accounts = {
  "management" = "419655711235"
  "sandbox"    = "512378128032"
  "security"   = "798807102550"
}

# Permission sets with policies and settings
permission_sets = {
  "AdminAccess" = {
    description      = "Full administrative access"
    session_duration = "PT8H"
    managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    tags = { AccessLevel = "admin" }
  }
  # Add more permission sets...
}

# User to permission set assignments
user_assignments = {
  "admin_users" = {
    users           = ["admin@company.com"]
    permission_sets = ["AdminAccess"]
    accounts        = ["management"]
  }
  # Add more assignments...
}
External Policy Files
Store complex inline policies as separate JSON files in the policies/ directory:
json{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::dev-*/*"
    }
  ]
}
📚 File Descriptions
FilePurposeterraform.tfProvider configuration and Terraform settingsvariables.tfVariable definitions with validation rulesterraform.tfvarsMain configuration file - customize thislocals.tfLocal values, computations, and external policy mappingsdata.tfData sources for Identity Center users and groupsmain.tfCore resources: permission sets and assignmentsoutputs.tfOutput values for referencepolicies/Directory for external inline policy JSON files
🔧 Usage
Adding New Users

Ensure users exist in AWS Identity Center
Add user emails to appropriate assignment groups in terraform.tfvars:

hcluser_assignments = {
  "developers" = {
    users = [
      "existing@company.com",
      "newuser@company.com"  # Add new user here
    ]
    permission_sets = ["DeveloperAccess"]
    accounts        = ["development"]
  }
}
Adding New Permission Sets
Add to the permission_sets block in terraform.tfvars:
hclpermission_sets = {
  "DatabaseAdmin" = {
    description      = "Database administration access"
    session_duration = "PT6H"
    managed_policies = [
      "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
      "arn:aws:iam::YOUR_ACCOUNT:policy/CustomDatabasePolicy"
    ]
    tags = { AccessLevel = "database-admin" }
  }
}
Adding External Policy Files

Create JSON policy file: policies/my-policy.json
Add mapping in locals.tf:

hclexternal_policies = {
  "MyPermissionSet" = file("${path.module}/policies/my-policy.json")
}
Adding New AWS Accounts

Add to target_accounts in terraform.tfvars:

hcltarget_accounts = {
  "production" = "123456789012"
  "staging"    = "234567890123" 
  "new-env"    = "345678901234"  # New account
}

Reference in user assignments:

hcluser_assignments = {
  "team_leads" = {
    users           = ["lead@company.com"]
    permission_sets = ["AdminAccess"]
    accounts        = ["production", "new-env"]  # Include new account
  }
}
📋 Common Commands
bash# Initialize Terraform (first time or after backend changes)
terraform init

# Format Terraform files
terraform fmt

# Validate configuration
terraform validate

# Plan changes (dry run)
terraform plan

# Apply changes
terraform apply

# Show current state
terraform state list

# Show specific resource
terraform state show aws_ssoadmin_permission_set.this[\"AdminAccess\"]

# Show outputs
terraform output

# Destroy all resources (be careful!)
terraform destroy
🔒 Best Practices
Security

Least Privilege: Start with minimal permissions and expand as needed
Session Duration: Use appropriate session lengths (shorter for higher privileges)
Regular Audits: Review permissions and assignments quarterly
State File Security: Use remote backend (S3) for production deployments

Development Workflow

Test in Development: Always test changes in dev environment first
Version Control: Commit all changes to Git
Code Review: Review terraform plans before applying
Backup State: Regularly backup terraform.tfstate file

Naming Conventions

Permission Sets: Use descriptive names like DatabaseAdmin, ReadOnlyAccess
User Assignments: Use role-based names like developers, security_team
Accounts: Use environment names like production, staging, development

🔧 Troubleshooting
Common Issues
SSO Authentication Errors
bash# Refresh SSO session
aws sso login --profile management

# Verify credentials
aws sts get-caller-identity --profile management
User Not Found Errors

Verify user exists in AWS Identity Center console
Check exact email spelling in terraform.tfvars
Ensure user is active (not suspended)

Permission Denied

Verify your SSO user has required permissions:

sso:*
identitystore:*
organizations:DescribeOrganization



State File Issues
bash# Refresh state
terraform refresh

# Import existing resources if needed
terraform import aws_ssoadmin_permission_set.this[\"AdminAccess\"] arn:aws:sso:::permissionSet/ssoins-xxx/ps-xxx
Validation Errors
Environment Validation
If using custom environment names, update variables.tf:
hclvalidation {
  condition     = contains(["dev", "staging", "prod", "management"], var.environment)
  error_message = "Environment must be dev, staging, prod, or management."
}
Policy File Errors

Ensure JSON files are valid JSON format
Check file paths in locals.tf external_policies mapping
Verify policy syntax follows AWS IAM policy format

🚀 Advanced Usage
Remote Backend Setup
For production use, configure S3 remote backend:

Create S3 bucket and DynamoDB table
Update terraform.tf:

hclterraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "identity-center/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
Multiple Environments
Create separate directories for each environment:
environments/
├── dev/
│   ├── terraform.tfvars
│   └── backend.conf
├── staging/
│   ├── terraform.tfvars
│   └── backend.conf
└── prod/
    ├── terraform.tfvars
    └── backend.conf
📞 Support
For issues and questions:

Check the troubleshooting section above
Review AWS Identity Center documentation
Check Terraform AWS provider documentation
Open an issue in the project repository

🔄 Version History

v1.0: Initial release with basic permission sets and user assignments
v1.1: Added external policy file support
v1.2: Enhanced multi-account support and validation


Note: Remember to customize terraform.tfvars with your actual user emails, account IDs, and organizational requirements before deploying.