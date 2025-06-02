# Define parameters
param (
    [string]$ResourceGroupName = "SOC_Central",
    [string]$WorkspaceName = "SOC-Central",
    [string]$WorkspaceId  = "43db1f06-99a8-4153-9ec1-79c7e076957b"
)

# Get Sentinel alert rules
$alertRules = Get-AzSentinelAlertRule -ResourceGroupName $ResourceGroupName -WorkspaceName $WorkspaceName

# If WorkspaceId is not provided, try to retrieve it dynamically
if (-not $WorkspaceId) {
    $workspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName $ResourceGroupName | Where-Object { $_.Name -eq $WorkspaceName }
   
    if ($workspace) {
        $WorkspaceId = $workspace.CustomerId
    } else {
        Write-Host "Error: Sentinel Workspace '$WorkspaceName' not found in resource group '$ResourceGroupName'." -ForegroundColor Red
        exit
    }
}

# Total number of rules
$totalRules = $alertRules.Count

# Calculate count of enabled rules
$enabledCount = ($alertRules | Where-Object { $_.Enabled -eq $true }).Count
$enabledPercentage = if ($totalRules -gt 0) { ($enabledCount / $totalRules) * 100 } else { 0 }

# Calculate count of rules with entity mapping
$entityMappingCount = ($alertRules | Where-Object { $_.EntityMapping }).Count
$entityMappingPercentage = if ($totalRules -gt 0) { ($entityMappingCount / $totalRules) * 100 } else { 0 }

# Query Sentinel incidents for the last 90 days
$query = @"
SecurityIncident
| where TimeGenerated >= ago(90d)
| summarize IncidentCount = count() by Title
"@

# Execute the query
$incidents = Invoke-AzOperationalInsightsQuery -WorkspaceId $WorkspaceId -Query $query

# Validate returned data
if (!$incidents.Results) {
    Write-Host "Warning: No incident data found for the last 90 days." -ForegroundColor Yellow
}

# Build lookup table from incident query results
$incidentLookup = @{}
foreach ($incident in $incidents.Results) {
    $incidentLookup[$incident.Title] = $incident.IncidentCount
}

# Merge alert rules with incident data using lookup table
$formattedRules = $alertRules | Select-Object DisplayName,
                                       @{Name="EntityMappingConfigured"; Expression={if ($_.EntityMapping) { "True" } else { "False" }}},
                                       Severity,
                                       @{Name="Tactic"; Expression={($_.Tactic -join ", ")}},  
                                       QueryFrequency,  
                                       Enabled,  
                                       IncidentConfigurationCreateIncident,  
                                       Kind,  
                                       @{Name="Triggered Incidents (Last 90 Days)"; Expression={
                                           if ($incidentLookup.ContainsKey($_.DisplayName)) {
                                               $incidentLookup[$_.DisplayName]
                                           } else {
                                               0
                                           }
                                       }}

# Format summary report
$summary = [PSCustomObject]@{
    "Total Rules" = $totalRules
    "Enabled Rules (%)" = "{0:N2}" -f $enabledPercentage
    "Rules with Entity Mapping (%)" = "{0:N2}" -f $entityMappingPercentage
}

# Output results in a structured format
Write-Host "`n=== Sentinel Alert Rules Summary ===`n" -ForegroundColor Cyan
$summary | Format-Table -AutoSize

Write-Host "`n=== Detailed Alert Rule Insights ===`n" -ForegroundColor Yellow
$formattedRules | Format-Table -AutoSize

# Define output paths
$HtmlOutputPath = "C:\Users\jaredgraff\Documents\REPO\Powershell\Sentinel_Report.html"
$ExcelOutputPath = "C:\Users\jaredgraff\Documents\REPO\Powershell\Sentinel_Report.xlsx"

### **Export to Excel (Instead of CSV)**
$formattedRules | Export-Excel -Path $ExcelOutputPath -WorksheetName "SentinelData" -AutoSize -BoldTopRow

Write-Host "Excel report saved to: $ExcelOutputPath" -ForegroundColor Green


### **Export to HTML**
$htmlSummary = $summary | ConvertTo-Html -Property "Total Rules", "Enabled Rules (%)", "Rules with Entity Mapping (%)" -Title "Sentinel Analytics Rules Report"
$htmlRules = $formattedRules | ConvertTo-Html -Property DisplayName, EntityMappingConfigured, Severity, Tactic, QueryFrequency, Enabled, IncidentConfigurationCreateIncident, Kind, "Triggered Incidents (Last 90 Days)" -Title "Detailed Alert Rules"

# Add basic styling for readability
$htmlHeader = @"
<!DOCTYPE html>
<html>
<head>
    <title>Sentinel Analytics Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h2 { color: #2E86C1; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #2E86C1; color: white; }
    </style>
</head>
<body>
<h2>Azure Sentinel Analytics Report</h2>
<h3>Detailed Alert Rules</h3>
<table>
    <tr>
        <th>Display Name</th>
        <th>Entity Mapping Configured</th>
        <th>Severity</th>
        <th>Tactic</th>
        <th>Query Frequency</th>
        <th>Enabled</th>
        <th>Incident Configuration</th>
        <th>Kind</th>
        <th>Triggered Incidents (Last 90 Days)</th>
    </tr>
"@

# Generate rows for the detailed rules table
$htmlBody = $formattedRules | ForEach-Object {
    "<tr><td>$($_.DisplayName)</td><td>$($_.EntityMappingConfigured)</td><td>$($_.Severity)</td><td>$($_.Tactic)</td><td>$($_.QueryFrequency)</td><td>$($_.Enabled)</td><td>$($_.IncidentConfigurationCreateIncident)</td><td>$($_.Kind)</td><td>$($_.'Triggered Incidents (Last 90 Days)')</td></tr>"
}

$htmlFooter = @"
</table>
</body>
</html>
"@

# Save the report as an HTML file
($htmlHeader + ($htmlBody -join "`n") + $htmlFooter) | Out-File -Encoding UTF8 $HtmlOutputPath

Write-Host "HTML report saved to: $HtmlOutputPath" -ForegroundColor Green
