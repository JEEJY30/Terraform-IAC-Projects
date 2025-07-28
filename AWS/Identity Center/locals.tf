locals {
  # External policy files - add your policy files here
  external_policies = {
    "DeveloperAccess" = file("${path.module}/policies/developer-policy.json")
    # "DatabaseAdmin"   = file("${path.module}/policies/database-admin-policy.json")
    # "SecurityAudit"   = file("${path.module}/policies/security-audit-policy.json")
    # Add more policies as needed
  }

  # Flatten user assignments for for_each loops
  user_assignments = flatten([
    for assignment_key, assignment in var.user_assignments : [
      for user in assignment.users : [
        for permission_set in assignment.permission_sets : [
          for account in assignment.accounts : {
            key             = "${assignment_key}-${user}-${permission_set}-${account}"
            user            = user
            permission_set  = permission_set
            account         = account
          }
        ]
      ]
    ]
  ])
  
  # Convert to map for for_each
  user_assignment_map = {
    for assignment in local.user_assignments : assignment.key => assignment
  }
  
  # Common tags
  common_tags = {
    Project     = "identity-center"
    ManagedBy   = "terraform"
    Environment = var.environment
  }
}