function Set-EvergreenProxy {
    <#
        .SYNOPSIS
            Set proxy server and credentials information into environment variables that other functions can use
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false, Position = 0, ParameterSetName = 'Set')]
        [System.String] $Proxy,

        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'Set')]
        [System.Management.Automation.PSCredential]
        $ProxyCredential = [System.Management.Automation.PSCredential]::Empty,

        [Parameter(ParameterSetName = 'Clear')]
        [switch]$Clear
    )

    begin {}
    process {
        try {
            if ($PSCmdlet.ParameterSetName -eq 'Set') {

                if ($PSBoundParameters.ContainsKey('Proxy')) {
                    if ($PSCmdlet.ShouldProcess('Set proxy server variable', 'Proxy')) {
                        $params = @{
                            Name  = 'EvergreenProxy'
                            Value = $Proxy
                            Scope = 'Script'
                            Force = $true
                        }
                        New-Variable @params
                    }
                }
                if ($PSBoundParameters.ContainsKey('ProxyCredential')) {
                    if ($PSCmdlet.ShouldProcess('Set proxy credential variable', 'ProxyCredential')) {
                        $params = @{
                            Name  = 'EvergreenProxyCreds'
                            Value = $ProxyCredential
                            Scope = 'Script'
                            Force = $true
                        }
                        New-Variable @params
                    }
                }

            }
            elseif ($PSCmdlet.ShouldProcess('Remove proxy settings', 'Clear')) {

                foreach ($VariableName in @('EvergreenProxyCreds', 'EvergreenProxy')) {
                    if (Test-Path -Path ('Variable:{0}' -f $VariableName)) {
                        $params = @{
                            Name  = 'Clear'
                            Scope = 'Script'
                            Force = $true
                        }
                        Remove-Variable @params
                    }
                }

            }
        }
        catch [System.Exception] {
            throw $_
        }
    }
}
