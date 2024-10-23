function get-APIInstanceObjectOAuth2 {
    [CmdletBinding()]
    param (
        # Instance
        [Parameter(Mandatory=$true)]
        [string]
        $Instance
        
    )
    
    begin {
    }
    
    process {
        
        $result = ($global:PSAPIClient_AvailablieInstanceOAUT2 | Where-Object { $_.InstanceName -eq ${Instance} }).InstanceObject
        
    }
    
    end {
        return $result
    }
}