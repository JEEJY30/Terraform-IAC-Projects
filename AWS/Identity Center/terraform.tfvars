# Environment configuration
environment = "management"
aws_region  = "us-east-1"

# Target accounts - UPDATE THESE WITH YOUR ACTUAL ACCOUNT IDs
target_accounts = {
  "management" = "419655711235"  # Replace with your actual account IDs
  "sandbox"    = "512378128032"  # You can use the same account for testing
  "security"   = "798807102550"
}

# Permission sets configuration
permission_sets = {
  "AdminAccess" = {
    description      = "Full administrative access"
    session_duration = "PT8H"
    managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    tags = {
      AccessLevel = "admin"
    }
  }
  
  "DeveloperAccess" = {
    description      = "Developer access with limited permissions"
    session_duration = "PT4H"
    managed_policies = ["arn:aws:iam::aws:policy/PowerUserAccess"]
    tags = {
      AccessLevel = "developer"
    }
  }
  
  "ReadOnlyAccess" = {
    description      = "Read-only access to AWS resources"
    session_duration = "PT2H"
    managed_policies = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
    tags = {
      AccessLevel = "readonly"
    }
  }
}

# User assignments - UPDATE THESE WITH YOUR ACTUAL USER EMAILS FROM IDENTITY CENTER
user_assignments = {
  "admin_users" = {
    users           = ["test@gio1818ggggmail.onmicrosoft.com"]  # Replace with actual admin user emails
    permission_sets = ["AdminAccess"]
    accounts        = ["management"]
  }
  
  "developers" = {
    users           = ["test@gio1818ggggmail.onmicrosoft.com"]  # Replace with actual dev user emails
    permission_sets = ["DeveloperAccess", "ReadOnlyAccess"]
    accounts        = ["sandbox"]
  }
}