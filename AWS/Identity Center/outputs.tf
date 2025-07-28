output "permission_set_arns" {
  description = "ARNs of created permission sets"
  value       = { for k, v in aws_ssoadmin_permission_set.this : k => v.arn }
}

output "instance_arn" {
  description = "ARN of the Identity Center instance"
  value       = var.sso_instance_arn
}

output "identity_store_id" {
  description = "ID of the Identity Store"
  value       = local.identity_store_id
}

output "assignments_summary" {
  description = "Summary of account assignments"
  value = {
    total_assignments = length(aws_ssoadmin_account_assignment.user_assignments)
    permission_sets   = keys(aws_ssoadmin_permission_set.this)
  }
}