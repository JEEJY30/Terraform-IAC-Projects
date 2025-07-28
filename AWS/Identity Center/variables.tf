variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod", "management"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "sso_instance_arn" {
  description = "ARN of the AWS SSO instance"
  type        = string
  default     = "arn:aws:sso:::instance/ssoins-7223aa25d5560e68"
}

variable "target_accounts" {
  description = "Map of account names to account IDs"
  type        = map(string)
}

variable "permission_sets" {
  description = "Configuration for permission sets"
  type = map(object({
    description      = string
    session_duration = string
    managed_policies = list(string)
    inline_policy    = optional(string)
    tags            = optional(map(string), {})
  }))
}

variable "user_assignments" {
  description = "User assignments to permission sets"
  type = map(object({
    users           = list(string)
    groups          = optional(list(string), [])
    permission_sets = list(string)
    accounts        = list(string)
  }))
}