Import-Csv -Path azureresources.csv | ForEach-Object {
    $tags = $_.Tags | ConvertFrom-Json
    if ($tags -ne $null) {
        Set-AzResourceGroup -Name $_.ResourceGroupName -Tag $tags
    }
}
