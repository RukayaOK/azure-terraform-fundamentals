variable resource_group_name {
  type        = string
  description = "description"
}

variable location {
  type        = string
  description = "description"
  default     = "ukwest"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID where resources will be deployed."
}

variable "client_id" {
  type        = string
  description = "Subscription ID where resources will be deployed."
}

variable "client_secret" {
  type        = string
  description = "Subscription ID where resources will be deployed."
}

variable "tenant_id" {
  type        = string
  description = "Subscription ID where resources will be deployed."
}