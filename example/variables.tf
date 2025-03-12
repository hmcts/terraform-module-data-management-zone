variable "env" {
  default = "test"
}

variable "hub_subscription_id" {
  default = "fb084706-583f-4c9a-bdab-949aac66ba5c"
}

variable "sdsptl_subscription_id" {
  default = "6c4d2513-a873-41b4-afdd-b05a33206631"
}

variable "hub_vnet_name" {
  default = "hmcts-hub-nonprodi"
}

variable "hub_resource_group_name" {
  default = "hmcts-hub-nonprodi"
}

variable "default_route_next_hop_ip" {
  default = "10.11.72.36/32"
}

variable "common_tags" {
  description = "Common tag to be applied to resources"
  type        = map(string)
  default     = {}
}

variable "eventhub_ns_sku" {
  description = "Event Hub Namespace SKU"
  type        = string
}

variable "services" {
  description = "Map of Event Hubs with configurations"
  type = map(object({
    partition_count   = number
    message_retention = string
  }))
}

variable "eventhub_auth_rules" {
  description = "Allows custom authorisation rules to be created for eventhubs"
  type = map(object({
    name   = string
    listen = bool
    send   = bool
    manage = bool
  }))
}

variable "eventhub_namespace_auth_rules" {
  description = "Allows custom authorisation rules to be created for eventhub namespaces"
  type = map(object({
    name   = string
    listen = bool
    send   = bool
    manage = bool
  }))
  default = {}
}

variable "eventhub_consumer_groups" {
  description = "Allows custom authorisation rules to be created for eventhub namespaces"
  type = map(object({
    name = string
  }))
}

