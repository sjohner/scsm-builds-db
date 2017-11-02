# Calculate VM expiry date
$lifetimedays = $env:vmLifetime
$today = Get-Date -Hour 0 -Minute 00 -Second 00
$expirydate = $today.AddDays($lifetimedays)
Write-Host "##vso[task.setvariable variable=expiryDate]$expirydate"