[cmdletbinding()]
Param(
	[Parameter(Mandatory=$True)][int]$vmLifetimeDays
)

# Calculate VM expiry date
Write-Host "Lifetime: $($env:vmLifetime)"
$today = Get-Date -Hour 0 -Minute 00 -Second 00
$expirydate = $today.AddDays($vmLifetimeDays)

#Set VSTS release variable
Write-Host "##vso[task.setvariable variable=vmExpirationDate]$expirydate"
Write-Host $env:vmExpirationDate
