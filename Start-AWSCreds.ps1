function Start-AWSCreds {
    $endpoint = "<SAML_ENDPOINT>";
    $epName = Set-AWSSamlEndpoint -Endpoint $endpoint -StoreAs ADFS -AuthenticationType NTLM;
    $list = Set-AWSSamlRoleProfile -StoreAll -EndpointName $epName
    $printlist = @()
    for($i=1; $i -le $list.length; $i++) { $printlist += "&$i - " + $list[$i-1] }
    $opt = [System.Management.Automation.Host.ChoiceDescription[]] $printlist
    $res = $host.UI.PromptForChoice("AWS Role","Which role would you like to assume?",$opt,0)
    Set-AWSCredential -ProfileName $list[$res] -Scope Global
}
