Import-Csv -Path azureresources.csv | ForEach-Object {
    # Convert the tags value from Json to a custom object
    $tags = $_.Tags | ConvertFrom-Json
    # Check if the tags value is not null
    if ($tags -ne $null) {
        # Create an empty hashtable
        $hashtable = @{}
        # Loop through the properties of the custom object and add them to the hashtable
        $tags.psobject.properties | ForEach-Object {
            $hashtable[$_.Name] = $_.Value
        }
        "Setting tags values for the $_ and $hashtable" 
        # Set the resource group with the hashtable as the tag parameter
        Set-AzContext -Subscription $_.SubscriptionName
        Set-AzResourceGroup -Id $_.ResourceId -Tag $hashtable 
    }
}
