<#
Copyright (c) 2018 VMware, Inc.  All rights reserved

The BSD-2 license (the "License") set forth below applies to all parts of the Desired State Configuration Resources for VMware project.  You may not use this file except in compliance with the License.

BSD-2 License

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

$script:configurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowPlainTextPassword = $true
            VMHosts = @(
                @{
                    Server = '<server>'
                    User = '<user>'
                    Password = '<password>'
                },
                @{
                    Server = '<server>'
                    User = '<user>'
                    Password = '<password>'
                }
            )
        }
    )
}

Configuration VMHostSettings_Config {
    Import-DscResource -ModuleName VMware.vSphereDSC

    Node $AllNodes.NodeName {
        foreach ($vmHost in $AllNodes.VMHosts) {
            $Server = $vmHost.Server
            $User = $vmHost.User
            $Password = $vmHost.Password | ConvertTo-SecureString -asPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential($User, $Password)

            VMHostNtpSettings "VMHostNtpSettings_$($Server)" {
                Name = $Server
                Server = $Server
                Credential = $Credential
                NtpServer = @('0.bg.pool.ntp.org', '1.bg.pool.ntp.org', '2.bg.pool.ntp.org')
                NtpServicePolicy = 'automatic'
            }

            VMHostTpsSettings "VMHostTpsSettings_$($Server)" {
                Name = $Server
                Server = $Server
                Credential = $Credential
                ShareScanTime = 50
                ShareScanGHz = 2
                ShareRateMax = 1000
                ShareForceSalting = 1
            }

            VMHostSettings "VMHostSettings_$($Server)" {
                Name = $Server
                Server = $Server
                Credential = $Credential
                Motd = 'Hello World from motd!'
                Issue = 'Hello World from issue!'
            }

            VMHostService "VMHostService_$($Server)" {
                Name = $Server
                Server = $Server
                Credential = $Credential
                Key = 'TSM-SSH'
                Policy = 'On'
                Running = $true
            }
        }
    }
}

VMHostSettings_Config -ConfigurationData $script:configurationData
