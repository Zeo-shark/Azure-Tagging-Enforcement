# Import the CSV file
$csv = Import-Csv -Path "azureresourcescolumns.csv" 

# Loop through each row of the CSV file
foreach ($row in $csv) {
    # Create an empty hashtable
    $hashtable = @{} 

    # Loop through each property of the row
    foreach ($property in $row.psobject.properties) {
      # Check if the property name ends with 'tag'
      if ($property.Name -like '*tag') {
        # Add the property name and value to the hashtable
        if ($property.Value -ne "-" -and $property.Value -ne "") {
          # Test the regex pattern against the string
          if ($property.Name -match "\((.*)\)"){
          $hashtable[$matches[1]] = $property.Value
          }
        }
      }
    }
  
    # Print the hashtable
    Set-AzContext -Subscription ($row.SubscriptionName -split " ")[0]
    Set-AzResourceGroup -Name $row.Name -Tag $hashtable 
  }