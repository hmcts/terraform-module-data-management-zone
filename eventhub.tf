resource "azurerm_eventhub_namespace" "eventhub-namespace" {
  name                = "${var.env}-dlrm-eventhub-ns"
  location            = var.location
  resource_group_name = local.resource_group
  sku                 = var.eventhub_ns_sku
  tags                = var.common_tags
  zone_redundant      = var.zone_redundant
}

resource "azurerm_eventhub" "eventhub" {
  for_each            = toset(var.services)
  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = local.resource_group
  partition_count     = 4
  message_retention   = var.message_retention
}

resource "azurerm_eventhub_namespace_authorization_rule" "eventhub-sender" {
  name                = "dlrm-eventhub-namespace-sender"
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = local.resource_group
  listen              = false
  send                = true
  manage              = false
}
