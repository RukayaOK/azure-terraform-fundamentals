variable "location" {
  type        = string
  description = "description"
  default     = "ukwest"
}

variable "tenant_id" {
  type        = string
  description = "Subscription ID where resources will be deployed."
}

variable "prod_resource_group_name" {
  type        = string
  description = "description"
}

variable "prod_subscription_id" {
  type        = string
  description = "Subscription ID where resources will be deployed."
}

variable "prod_client_id" {
  type        = string
  description = "Subscription ID where resources will be deployed."
}

variable "prod_client_secret" {
  type        = string
  description = "Subscription ID where resources will be deployed."
}

variable "dev_resource_group_name" {
  type        = string
  description = "description"
}

variable "dev_subscription_id" {
  type        = string
  description = "Subscription ID where resources will be deployed."
}

variable "dev_client_id" {
  type        = string
  description = "Subscription ID where resources will be deployed."
}

variable "dev_client_secret" {
  type        = string
  description = "Subscription ID where resources will be deployed."
}