# Get Identity Store ID
data "aws_ssoadmin_instances" "main" {}

locals {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
}

# Get all users mentioned in assignments
data "aws_identitystore_user" "users" {
  for_each          = toset(flatten([for assignment in var.user_assignments : assignment.users]))
  identity_store_id = local.identity_store_id
  
  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.value
    }
  }
}

# Get all groups mentioned in assignments
data "aws_identitystore_group" "groups" {
  for_each          = toset(flatten([for assignment in var.user_assignments : assignment.groups if assignment.groups != null]))
  identity_store_id = local.identity_store_id
  
  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }
}