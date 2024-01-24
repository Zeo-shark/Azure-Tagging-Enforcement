# Output Path

$outputPath = "C:\Customer Accounts\WNS CX\Cost Allocation Excel Automation\TagRemediation\azureresources.csv"

  

# Connect to Azure

Connect-AzAccount

  

# Get All Subscriptions

$subscriptions = Get-AzSubscription

$subscriptions | Format-Table SubscriptionId, Name

 

if (Test-Path $outputPath) { 
    "File $outputPath already exists. Delete? y/n [Default: y)"

    $remove = read-host
    if([String]::IsNullOrWhiteSpace($remove) -or $remove.ToLower().Equals('y')) {
        Remove-Item $outputPath
    }
}

  

ForEach($subscription in $subscriptions) {
    # Select Azure Subscription
    $subscriptionName = $subscription.Name
    $subscriptionId = $subscription.Id

    [void] (Select-AzSubscription -Context (Set-AzContext -SubscriptionID $subscriptionId))

    # Export Resource Information
    $export = Get-AzResourceGroup | Select-Object @{Label="SubscriptionName";Expression={ $subscriptionName } }, ResourceGroupName, @{Label="Tags";Expression={$_.Tags | ConvertTo-Json -Compress}} # ResourceGroup
    $export | Export-CSV $outputPath -Append -Force -NoTypeInformation
    "Exported " + $subscriptionId + " - " + $subscriptionName
}




 

"Export Completed!"