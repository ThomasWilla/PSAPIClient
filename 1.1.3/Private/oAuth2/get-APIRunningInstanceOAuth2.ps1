function get-APIRunningInstanceOAuth2 {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
    }
    
    process {
        
        if ([string]::IsNullOrEmpty($global:PSAPIClient_AvailablieInstanceOAUT2.InstanceName)) {
            $result = ""           
        }
        else {
            $result = $global:PSAPIClient_AvailablieInstanceOAUT2.InstanceName
        }
        
    }
    
    end {
        return $result
    }
}