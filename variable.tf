variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "cloud_shell_source" {
  type = string
}

variable "management_ip" {
  type = string
}

variable "domain_name_prefix" {
  type = string
}
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "b462d350-1ac8-4373-a8c5-deadc8357530"
}