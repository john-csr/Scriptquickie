<#PSScriptInfo
.VERSION 1.0
.AUTHOR John Core
.DESCRIPTION Powershell launch tool for file select and run
#>



Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "PowerShell Script Loader"
$form.Size = New-Object System.Drawing.Size(400,150)
$form.StartPosition = "CenterScreen"

# Label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Select a PowerShell script:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(10,20)
$form.Controls.Add($label)

# Textbox to show file path
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Size = New-Object System.Drawing.Size(260,20)
$textBox.Location = New-Object System.Drawing.Point(10,45)
$form.Controls.Add($textBox)

# Browse button
$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Text = "Browse"
$browseButton.Location = New-Object System.Drawing.Point(280,42)
$browseButton.Add_Click({
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Filter = "PowerShell Scripts (*.ps1)|*.ps1|All Files (*.*)|*.*"
    $dialog.InitialDirectory = "C:\"
    if ($dialog.ShowDialog() -eq "OK") {
        $textBox.Text = $dialog.FileName
    }
})
$form.Controls.Add($browseButton)

# Run button
$runButton = New-Object System.Windows.Forms.Button
$runButton.Text = "Run Script"
$runButton.Location = New-Object System.Drawing.Point(150,80)
$runButton.Add_Click({
    $scriptPath = $textBox.Text
    if (Test-Path $scriptPath) {
        try {
            & $scriptPath
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error running script: $_")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Script not found.")
    }
})
$form.Controls.Add($runButton)

# Show the form
$form.Topmost = $true
$form.ShowDialog()
