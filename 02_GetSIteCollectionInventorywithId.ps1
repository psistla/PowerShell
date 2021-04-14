Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

function Get-AllInventory([string]$siteUrl, [string]$ExportToPath, [string]$filename )

{
 
#Get the site collection
$Site = Get-SPSite $SiteURL

Write-host -ForegroundColor black -BackgroundColor green "... Working on Site Collection: "$SiteURL
 
$ResultData = @()
#Get All Sites of the Site collection
Foreach($web in $Site.AllWebs)

{
    Write-host -f Yellow "Processing Site: "$Web.URL
  
    #Get all lists - Exclude Hidden System lists
    $ListCollection = $web.lists | Where-Object  { ($_.hidden -eq $false) -and ($_.IsSiteAssetsLibrary -eq $false)}
 
    #Iterate through All lists and Libraries
    ForEach ($List in $ListCollection)

    {
            $ResultData+= New-Object PSObject -Property @{
            'CreatedBy' = $List.Author.DisplayName
            'LastModified' = $List.LastItemModifiedDate.ToString();
            'SiteTitle' = $Web.Title
            'SiteURL' = $Web.URL           
            'ListLibraryName' = $List.Title
            'ListURL' = "$($Web.Url)/$($List.RootFolder.Url)"
            'GUID' = $List.id
            'ItemCount' = $List.ItemCount
    }
} 

}

$exportfile = $ExportToPath + "\" + $filename + ".csv"

#Export the data to CSV
$ResultData | Export-Csv $exportfile -NoTypeInformation
Write-host -f Green "Report generation successful..."
Write-host -f Green "Path: " $exporttopath

}

Get-AllInventory -siteUrl "https://intranet.tstech.com/sites/SPPC/" -ExportToPath "C:\PSExports\" -filename "SPPC-Inventory"


