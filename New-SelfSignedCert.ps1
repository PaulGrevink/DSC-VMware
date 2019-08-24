<#
Generate Self-signed certificate

Download script from: 
https://gallery.technet.microsoft.com/scriptcenter/Self-signed-certificate-5920a7c6
 
#>

#load function

. "C:\VMwareDSC\New-SelfSignedCertificateEx.ps1"# generate CertNew-SelfSignedCertificateEx -Subject 'CN=Cert' -EnhancedKeyUsage 'Document Encryption' -StoreLocation LocalMachine -FriendlyName 'SelfSigned'# Check Cert$cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.FriendlyName -eq 'SelfSigned'}$cert # Cert can be exportedExport-Certificate -Cert $cert -FilePath C:\VMwareDSC\Cert.cer -Force