<#PSScriptInfo
.VERSION 1.0
.DATE 8-9-2025
.AUTHOR John C.
.DESCRIPTION Scriptquickie tool for launching and editing PowerShell scripts
#># Define output path
$reportPath = "$env:USERPROFILE\Desktop\DiskReport.html"

# Start HTML content
$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Disk Information Report</title>
    <style>
        body { font-family: Arial; background-color: #f4f4f4; padding: 20px; }
        h1 { color: #2c3e50; }
        h2 { color: #2c3e50; border-bottom: 2px solid #ccc; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #34495e; color: white; }
        tr:nth-child(even) { background-color: #ecf0f1; }
        .section { background-color: #bdc3c7; padding: 10px; margin-top: 20px; }
    </style>
</head>
<body>
    <h1>Disk Information Report</h1>
"@

# Function to convert objects to HTML tables
function Convert-ToHtmlTable {
    param ($title, $objects)
    if (!$objects) { return "" }

    $section = "<div class='section'><h2>$title</h2><table><tr>"
    foreach ($property in $objects[0].PSObject.Properties.Name) {
        $section += "<th>$property</th>"
    }
    $section += "</tr>"

    foreach ($obj in $objects) {
        $section += "<tr>"
        foreach ($property in $obj.PSObject.Properties.Name) {
            $value = $obj.$property
            if ($property -match "Size|FreeSpace|SizeRemaining" -and $value -is [int64]) {
                $value = [math]::Round($value / 1MB, 2) + " MB"
            }
            $section += "<td>$value</td>"
        }
        $section += "</tr>"
    }

    $section += "</table></div>"
    return $section
}

# Collect and format data
$physicalDisks = Get-PhysicalDisk | Select DeviceId, FriendlyName, MediaType, @{Name="Size";Expression={[math]::Round($_.Size / 1MB, 2)}}, HealthStatus, OperationalStatus, BusType
$diskDrives    = Get-Disk | Select Number, Model, @{Name="Size";Expression={[math]::Round($_.Size / 1MB, 2)}}, PartitionStyle, IsBoot, IsSystem
$partitions    = Get-Partition | Select DiskNumber, PartitionNumber, Type, @{Name="Size";Expression={[math]::Round($_.Size / 1MB, 2)}}, IsBoot, IsSystem
$volumes       = Get-Volume | Select DriveLetter, FileSystem, FileSystemLabel, @{Name="Size";Expression={[math]::Round($_.Size / 1MB, 2)}}, @{Name="SizeRemaining";Expression={[math]::Round($_.SizeRemaining / 1MB, 2)}}, HealthStatus, DriveType
$logicalDisks  = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select DeviceID, VolumeName, FileSystem, @{Name="Size";Expression={[math]::Round($_.Size / 1MB, 2)}}, @{Name="FreeSpace";Expression={[math]::Round($_.FreeSpace / 1MB, 2)}}

# Add sections to HTML
$html += Convert-ToHtmlTable "Physical Disks" $physicalDisks
$html += Convert-ToHtmlTable "Disk Drives" $diskDrives
$html += Convert-ToHtmlTable "Partitions" $partitions
$html += Convert-ToHtmlTable "Volumes" $volumes
$html += Convert-ToHtmlTable "Logical Disk Usage" $logicalDisks

# Finalize and save HTML
$html += "</body></html>"
$html | Out-File -Encoding UTF8 -FilePath $reportPath

Write-Host "Disk report saved to: $reportPath" -ForegroundColor Green
