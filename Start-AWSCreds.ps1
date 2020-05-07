function Start-AWSCreds {
    if(Test-Connection <INTERNAL_ENDPOINT> -quiet -count 1) {
        $endpoint = "<SAML_ENDPOINT";
        $epName = Set-AWSSamlEndpoint -Endpoint $endpoint -StoreAs ADFS -AuthenticationType NTLM;
        if((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain) {
            $list = Set-AWSSamlRoleProfile -StoreAll -EndpointName $epName
        } else {
            $credential = Get-Credential -Message "Enter the domain credentials for the endpoint"
            $list = Set-AWSSamlRoleProfile -StoreAll -EndpointName $epName -NetworkCredential $credential
        }
        $printlist = @()
        for($i=1; $i -le $list.length; $i++) { $printlist += "&$i - " + $list[$i-1] }
        $opt = [System.Management.Automation.Host.ChoiceDescription[]] $printlist
        $res = $host.UI.PromptForChoice("AWS Role","Which role would you like to assume?",$opt,0)
        Set-AWSCredential -ProfileName $list[$res] -Scope Global
    } else {
        write-host "Could not connect to internal endpoint, please confirm your VPN is active."
    }
}
