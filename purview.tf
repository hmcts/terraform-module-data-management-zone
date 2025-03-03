resource "azurerm_purview_account" "this" {
  count                       = var.existing_purview_account == null ? 1 : 0
  name                        = "${local.name}-purview-${var.env}"
  resource_group_name         = local.resource_group
  location                    = local.location
  public_network_enabled      = false
  managed_resource_group_name = "${local.name}-purview-${var.env}"

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}

data "azurerm_purview_account" "existing" {
  count               = var.existing_purview_account == null ? 0 : 1
  name                = var.existing_purview_account
  resource_group_name = local.resource_group
}

resource "azurerm_private_endpoint" "purview_endpoint" {
  for_each            = local.purview_private_endpoints
  name                = "${local.name}-purview-endpoint-${each.key}-${var.env}"
  location            = local.location
  resource_group_name = local.resource_group
  subnet_id           = module.networking.subnet_ids["vnet-services"]

  private_service_connection {
    name                           = "${local.name}-purview-endpoint-${each.key}-connection-${var.env}"
    private_connection_resource_id = each.value.resource_id
    subresource_names              = [each.key]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = [each.value.private_dns_zone_id]
  }

  tags = var.common_tags
}
