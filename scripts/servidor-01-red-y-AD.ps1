# ===== Windows Server 2022 - Red + Active Directory (PowerShell como Administrador) =====
# 1) IP fija
$n=(Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object -First 1).Name
Set-NetIPInterface -InterfaceAlias $n -Dhcp Disabled
New-NetIPAddress -InterfaceAlias $n -IPAddress 10.20.35.3 -PrefixLength 28 -DefaultGateway 10.20.35.1
Set-DnsClientServerAddress -InterfaceAlias $n -ServerAddresses 10.20.35.3
Enable-NetFirewallRule -Name FPS-ICMP4-ERQ-In
Rename-Computer -NewName SRV-AAA -Restart

# 2) (tras reiniciar) Instalar AD DS y crear el bosque; el servidor se reinicia solo
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "lab20250035.local" -DomainNetbiosName "LAB20250035" -InstallDns -Force

# 3) (tras reiniciar) Grupos y usuarios
$p = ConvertTo-SecureString "Redes2025Lab" -AsPlainText -Force
foreach ($l in 0,5,10) {
  New-ADGroup -Name "Nivel$l" -GroupScope Global -GroupCategory Security
  New-ADUser -Name "user$l" -SamAccountName "user$l" -UserPrincipalName "user$l@lab20250035.local" -Enabled $false
  Set-ADAccountPassword -Identity "user$l" -NewPassword $p -Reset
  Enable-ADAccount -Identity "user$l"
  Add-ADGroupMember -Identity "Nivel$l" -Members "user$l"
}
