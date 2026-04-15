module "management_groups" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "0.19.1"
  count   = var.management_groups_enabled ? 1 : 0

  architecture_name                                                = module.config.outputs.management_group_settings.architecture_name
  parent_resource_id                                               = module.config.outputs.management_group_settings.parent_resource_id
  location                                                         = module.config.outputs.management_group_settings.location
  policy_default_values                                            = local.policy_default_values
  policy_assignments_to_modify                                     = local.policy_assignments_to_modify
  enable_telemetry                                                 = var.enable_telemetry
  management_group_hierarchy_settings                              = module.config.outputs.management_group_settings.management_group_hierarchy_settings
  retries                                                          = module.config.outputs.management_group_settings.retries
  subscription_placement                                           = module.config.outputs.management_group_settings.subscription_placement
  timeouts                                                         = module.config.outputs.management_group_settings.timeouts
  override_policy_definition_parameter_assign_permissions_set      = module.config.outputs.management_group_settings.override_policy_definition_parameter_assign_permissions_set
  override_policy_definition_parameter_assign_permissions_unset    = module.config.outputs.management_group_settings.override_policy_definition_parameter_assign_permissions_unset
  management_group_role_assignments                                = module.config.outputs.management_group_settings.management_group_role_assignments
  role_assignment_definition_lookup_enabled                        = module.config.outputs.management_group_settings.role_assignment_definition_lookup_enabled
  policy_assignment_non_compliance_message_settings                = module.config.outputs.management_group_settings.policy_assignment_non_compliance_message_settings
  role_assignment_name_use_random_uuid                             = module.config.outputs.management_group_settings.role_assignment_name_use_random_uuid
  subscription_placement_destroy_behavior                          = module.config.outputs.management_group_settings.subscription_placement_destroy_behavior
  subscription_placement_destroy_custom_target_management_group_id = module.config.outputs.management_group_settings.subscription_placement_destroy_custom_target_management_group_id
  policy_assignments_dependencies                                  = local.management_group_dependencies
  policy_role_assignments_dependencies                             = local.management_group_dependencies
  telemetry_additional_content                                     = var.telemetry_additional_content
}

# Enforce Germany West Central as the only allowed location using the built-in Azure Policy
resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locs-gwc"
  display_name         = "Allowed locations - Germany West Central"
  management_group_id  = "/providers/Microsoft.Management/managementGroups/mg-teamaztf"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  description          = "Enforces that resources can only be deployed to Germany West Central region"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["germanywestcentral"]
    }
  })
}
