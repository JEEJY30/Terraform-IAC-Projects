# Create permission sets
resource "aws_ssoadmin_permission_set" "this" {
  for_each = var.permission_sets
  
  name             = each.key
  description      = each.value.description
  instance_arn     = var.sso_instance_arn
  session_duration = each.value.session_duration
  
  tags = merge(local.common_tags, each.value.tags)
}

# Attach managed policies
resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = {
    for combo in flatten([
      for ps_name, ps_config in var.permission_sets : [
        for policy in ps_config.managed_policies : {
          key        = "${ps_name}-${basename(policy)}"
          ps_name    = ps_name
          policy_arn = policy
        }
      ]
    ]) : combo.key => combo
  }
  
  instance_arn       = var.sso_instance_arn
  managed_policy_arn = each.value.policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.ps_name].arn
}

# Attach inline policies
resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  for_each = {
    for ps_name, ps_config in var.permission_sets : ps_name => ps_config
    if ps_config.inline_policy != null
  }
  
  inline_policy      = each.value.inline_policy
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
}

# Create user assignments
resource "aws_ssoadmin_account_assignment" "user_assignments" {
  for_each = local.user_assignment_map
  
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn
  
  principal_id   = data.aws_identitystore_user.users[each.value.user].user_id
  principal_type = "USER"
  
  target_id   = var.target_accounts[each.value.account]
  target_type = "AWS_ACCOUNT"
}