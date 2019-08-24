[DSCLocalConfigurationManager()]
Configuration LCM_SelfSigned
{
    param
        (
            [Parameter(Mandatory=$true)]
            [string[]]$ComputerName,

            [Parameter(Mandatory=$true)]
            [string]$guid,

            [Parameter(Mandatory=$true)]
            [string]$thumbprint

        )
	Node $ComputerName {
		Settings {
		AllowModuleOverwrite = $True
		ConfigurationMode = 'ApplyAndMonitor'
		RefreshMode = 'Push'
		ConfigurationID = $guid
		CertificateID = $thumbprint
		}
	}
}

$ComputerName = 'localhost'
$cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.FriendlyName -eq 'SelfSigned'}
$cim = New-CimSession -ComputerName $ComputerName
$guid=[guid]::NewGuid()

LCM_SelfSigned -ComputerName $ComputerName -Guid $guid -Thumbprint $Cert.Thumbprint -OutputPath C:\VMwareDSC\S2
Set-DscLocalConfigurationManager -CimSession $cim -Path C:\VMwareDSC\S2 -Verbose
Get-DscLocalConfigurationManager -CimSession $cim
