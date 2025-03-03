variable "env" {
  description = "Environment value"
  type        = string
}

variable "common_tags" {
  description = "Common tag to be applied to resources"
  type        = map(string)
}

variable "default_route_next_hop_ip" {
  description = "IP address of the next hop for the default route, this will usually be the private ip config of the Palo Load Balancer."
  type        = string
}

variable "address_space" {
  description = "The address space covered by the virtual network."
  type        = list(string)
}

variable "hub_vnet_name" {
  description = "The name of the HUB virtual network."
  type        = string
}

variable "hub_resource_group_name" {
  description = "The name of the resource group containing the HUB virtual network."
  type        = string
}

#Event Hub

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
