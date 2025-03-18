resource "azurerm_eventhub_namespace" "eventhub-namespace" {
  name                 = "${var.env}-dlrm-eventhub-ns"
  location             = var.location
  resource_group_name  = local.resource_group
  sku                  = var.eventhub_ns_sku
  tags                 = var.common_tags
  capacity             = var.eventhub_capacity
  auto_inflate_enabled = var.auto_inflate_enabled
  network_rulesets {
    default_action                 = "Allow"
    public_network_access_enabled  = true
    trusted_service_access_enabled = false
  }
}

resource "azurerm_eventhub" "eventhub" {
  for_each            = var.services
  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = local.resource_group
  partition_count     = each.value.partition_count
  message_retention   = each.value.message_retention
}

resource "azurerm_eventhub_namespace_authorization_rule" "eventhub-sender" {
  name                = "dlrm-eventhub-namespace-sender"
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = local.resource_group
  listen              = false
  send                = true
  manage              = false
}

resource "azurerm_eventhub_namespace_authorization_rule" "eventhub_namespace_auth_rules" {
  for_each            = var.eventhub_namespace_auth_rules
  name                = each.value.name
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = local.resource_group
  listen              = each.value.listen
  send                = each.value.send
  manage              = each.value.manage
}


resource "azurerm_eventhub_authorization_rule" "eventhub_auth_rules" {
  for_each            = var.eventhub_auth_rules
  name                = each.value.name
  eventhub_name       = each.key
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = local.resource_group
  listen              = each.value.listen
  send                = each.value.send
  manage              = each.value.manage
}

resource "azurerm_eventhub_consumer_group" "eventhub_consumer_groups" {
  for_each            = var.eventhub_consumer_groups
  name                = each.value.name
  eventhub_name       = each.key
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = local.resource_group
}
