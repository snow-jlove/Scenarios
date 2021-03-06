# preamble
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction']='Stop'

# configuration
$VIServer = "172.16.10.30"
$nsxServer = "172.16.10.32"
$user = $Env:SELECTED_CREDENTIALS_USERNAME
$password = $Env:SELECTED_CREDENTIALS_PASSWORD

$sgName = "TestSG"
$port = "80"
$protocol = "TCP"

Import-Module PowerNSX

Connect-VIServer -Server $VIServer -User $user -Password $password
Connect-NsxServer -NsxServer $nsxServer -Username $user -Password $password

$sg = New-NsxSecurityGroup -Name $sgName
$fw = New-NsxFirewallSection -Name $sgName
$service = New-NsxService -Name "$sgName-$protocol-$port" -Protocol $protocol -port $port
$fw | New-NsxFirewallRule -Name "$sgName-$protocol-$port" -Destination $sg -Service $service -Action "allow"

