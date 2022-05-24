resource "azurerm_resource_group" "functionrg" {
  name     = "${var.prefix}-resources"
  location = var.location
}


resource "azurerm_servicebus_namespace" "servicebusns" {
  name = "xyzsevicebusn01s"
  location = azurerm_resource_group.functionrg.location
  resource_group_name = azurerm_resource_group.functionrg.name
  sku = "Standard"
  tags = {
    source = "terraform"
  }
}

resource "azurerm_servicebus_topic" "servicebustp" {
  name = "events"
  resource_group_name = azurerm_resource_group.functionrg.name
  namespace_name = azurerm_servicebus_namespace.functionrg.name
  enable_partitioning = true
}

// Create an Azure storage account
resource "azurerm_storage_account" "storageaccount" {
  name = "storageaccount"
  resource_group_name = azurerm_resource_group.functionrg.name
  location = azurerm_resource_group.functionrg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_application_insights" "appinsights" {
  name                = "appinsights"
  location            = azurerm_resource_group.functionrg.location
  resource_group_name = azurerm_resource_group.functionrg.name
  application_type    = "web"
  tags = {
    "Monitoring" = "functionApp"
    }
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name = "azure-functions-sample-service-plan"
  location = azurerm_resource_group.functionrg.location
  resource_group_name = azurerm_resource_group.functionrg.name
  kind = "FunctionApp"
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "functionapp" {
  name = "functionrg-functionapp"
  location = azurerm_resource_group.functionrg.location
  resource_group_name = azurerm_resource_group.functionrg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
  storage_connection_string = azurerm_storage_account.storageaccount.primary_connection_string
  app_settings = {
    "ServiceBusConnectionString" = "some-value"
  }

}
