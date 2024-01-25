## Apply Tag with Values
```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
      "utcShort": {
        "type": "string",
        "defaultValue": "[utcNow('d')]"
      },
      "location": {
        "type": "string",
        "defaultValue": "[resourceGroup().location]"
      }
    },
    "resources": [
      {
        "type": "Microsoft.Storage/storageAccounts",
        "apiVersion": "2021-04-01",
        "name": "[concat('storage', uniqueString(resourceGroup().id))]",
        "location": "[parameters('location')]",
        "sku": {
          "name": "Standard_LRS"
        },
        "kind": "Storage",
        "tags": {
          "Dept": "Finance",
          "Environment": "Production",
          "LastDeployed": "[parameters('utcShort')]"
        },
        "properties": {}
      }
    ]
  }
```

## Apply an object as tag

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
      "location": {
        "type": "string",
        "defaultValue": "[resourceGroup().location]"
      },
      "tagValues": {
        "type": "object",
        "defaultValue": {
          "Dept": "Finance",
          "Environment": "Production"
        }
      }
    },
    "resources": [
      {
        "type": "Microsoft.Storage/storageAccounts",
        "apiVersion": "2021-04-01",
        "name": "[concat('storage', uniqueString(resourceGroup().id))]",
        "location": "[parameters('location')]",
        "sku": {
          "name": "Standard_LRS"
        },
        "kind": "Storage",
        "tags": "[parameters('tagValues')]",
        "properties": {}
      }
    ]
  }
```

## Apply tags from RGs

```json
  {
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
      "location": {
        "type": "string",
        "defaultValue": "[resourceGroup().location]"
      }
    },
    "resources": [
      {
        "type": "Microsoft.Storage/storageAccounts",
        "apiVersion": "2021-04-01",
        "name": "[concat('storage', uniqueString(resourceGroup().id))]",
        "location": "[parameters('location')]",
        "sku": {
          "name": "Standard_LRS"
        },
        "kind": "Storage",
        "tags": {
          "Dept": "[resourceGroup().tags['Dept']]",
          "Environment": "[resourceGroup().tags['Environment']]"
        },
        "properties": {}
      }
    ]
  }

"tags": {
    "department": "[resourceGroup().tags.department]",
    "environment": "[resourceGroup().tags.environment]"
},
```

Reference document: [Add resource tags with ARM templates](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-tutorial-add-tags?tabs=azure-powershell)