// Resourece Group Creation
resource "azurerm_resource_group" "apimrg" {
  name     = "apim-rg"
  location = var.location
}

// API Management Creation
resource "azurerm_api_management" "apim" {
  name                = "sample-apim"
  location            = azurerm_resource_group.apimrg.location
  resource_group_name = azurerm_resource_group.apimrg.name
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"
}

// an API within APIM
resource "azurerm_api_management_api" "apimapi" {
  name                = "apim-api"
  resource_group_name = azurerm_resource_group.apimrg.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "apim API"
  path                = ""
  protocols           = ["https", "http"]

  import {
    content_format = "swagger-link-json"
    content_value  = "http://conferenceapi.azurewebsites.net/?format=json"
  }
}