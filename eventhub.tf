resource "azurerm_resource_group" "eventhub_resource_group" {
  name     = "${var.env}-dlrm-eventhub-rg"
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_eventhub_namespace" "eventhub-namespace" {
  name                = "${var.env}-dlrm-eventhub-ns"
  location            = var.location
  resource_group_name = azurerm_resource_group.eventhub_resource_group
  sku                 = var.eventhub_ns_sku
  tags                = var.common_tags
}

resource "azurerm_eventhub" "eventhub" {
  for_each            = toset(var.services)
  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = azurerm_eventhub_namespace.eventhub-namespace.resource_group_name
  partition_count     = 4
  message_retention   = var.message_retention
}

resource "azurerm_eventhub_namespace_authorization_rule" "eventhub-sender" {
  name                = "dlrm-eventhub-namespace-sender"
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = azurerm_resource_group.eventhub_resource_group

  listen = false
  send   = true
  manage = false
}