data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

data "azurerm_policy_definition" "allowed_locations_for_resource_groups" {
  display_name = "Allowed locations for resource groups"
}

locals {
  root_parent_management_group_resource_id = "/providers/Microsoft.Management/managementGroups/${var.root_parent_management_group_id}"
  enforced_location                        = var.starter_locations[0]
}

resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  display_name         = "Allowed locations"
  description          = "Restricts resource deployments to the configured starter location."
  management_group_id  = local.root_parent_management_group_resource_id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = [local.enforced_location]
    }
  })
}

resource "azurerm_management_group_policy_assignment" "allowed_locations_for_resource_groups" {
  name                 = "allowed-locations-rg"
  display_name         = "Allowed locations for resource groups"
  description          = "Restricts resource group deployments to the configured starter location."
  management_group_id  = local.root_parent_management_group_resource_id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations_for_resource_groups.id

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = [local.enforced_location]
    }
  })
}
