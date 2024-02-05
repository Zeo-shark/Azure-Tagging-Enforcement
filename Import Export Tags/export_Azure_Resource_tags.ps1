# Initialise output array
$Output = @()
$outputPath = "C:\Customer Accounts\WNS CX\Cost Allocation Excel Automation\TagRemediation\azureresourcescolumns.csv"



Connect-AzAccount
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
    $Subscription = Select-AzSubscription -SubscriptionId $subscriptionId # -Tenant "dc165e1d-5d8f-405b-8521-0b1dc3a1aee3"



    if($Subscription){
        foreach ($item in $Subscription)
        {
            $item | Select-AzSubscription
    
            # Collect all the resources or resource groups (comment one of below)
            $Resource = Get-AzResourceGroup
    
            # Obtain a unique list of tags for these groups collectively
            $UniqueTags = $Resource.Tags.GetEnumerator().Keys | Get-Unique -AsString | Sort-Object | Select-Object -Unique | Where-Object {$_ -notlike "hidden-*" }
    
            # Loop through the resource groups
            foreach ($ResourceGroup in $Resource) {
                # Create a new ordered hashtable and add the normal properties first.
                $RGHashtable = New-Object System.Collections.Specialized.OrderedDictionary
                $RGHashtable.Add("Name",$ResourceGroup.ResourceGroupName)
                $RGHashtable.Add("Location",$ResourceGroup.Location)
                $RGHashtable.Add("Id",$ResourceGroup.ResourceId)
                $RGHashtable.Add("ProvisioningState",$ResourceGroup.ProvisioningState)
                $RGHashtable.Add("SubscriptionName",$item.Name)

    
                # Loop through possible tags adding the property if there is one, adding it with a hyphen as it's value if it doesn't.
                if ($ResourceGroup.Tags.Count -ne 0) {
                    $UniqueTags | Foreach-Object {
                        if ($ResourceGroup.Tags[$_]) {
                            $RGHashtable.Add("($_) tag",$ResourceGroup.Tags[$_])
                        }
                        else {
                            $RGHashtable.Add("($_) tag","-")
                        }
                    }
                }
                else {
                    $UniqueTags | Foreach-Object { $RGHashtable.Add("($_) tag","-") }
                }
            
    
                # Update the output array, adding the ordered hashtable we have created for the ResourceGroup details.
                $Output += New-Object psobject -Property $RGHashtable
            }
    
            # Sent the final output to CSV
            $Output | Export-Csv -Path $outputPath -append -NoClobber -NoTypeInformation -Encoding UTF8 -Force
        }
    }
}
$inputCsv = Import-Csv $outputPath | Sort-Object * -Unique

$inputCsv | Export-Csv $outputPath -NoTypeInformation
$Output | Out-GridView