<#param(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.IO.FileInfo]$Path,
 
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet("ProductCode", "ProductVersion", "ProductName", "Manufacturer", "ProductLanguage", "FullVersion")]
    [string]$Property
)
#>
[System.IO.FileInfo]$Path = "C:\AutomatedLab.msi"
#[string]$Property = "productcode"

<# param(
    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
    [ValidateScript({Test-Path $_})]
    [IO.FileInfo]$Path
    )
    #>
    
    $WindowsInstaller = New-Object -com WindowsInstaller.Installer
    $MSIDatabase = $WindowsInstaller.GetType().InvokeMember(
    "OpenDatabase","InvokeMethod",$Null,
    $WindowsInstaller,@($Path.FullName,0))
    
    $View = $MSIDatabase.GetType().InvokeMember(
    "OpenView","InvokeMethod",$null,
    $MSIDatabase,"SELECT * FROM Property")
    
    $View.GetType().InvokeMember(
    "Execute", "InvokeMethod", $null, $View, $null)
    while($Record = $View.GetType().InvokeMember(
    "Fetch","InvokeMethod",$null,$View,$null))
    {
    @{ $Record.GetType().InvokeMember(
    "StringData","GetProperty",$null,$Record,1) =
    $Record.GetType().InvokeMember(
    "StringData","GetProperty",$null,$Record,2)}
    }
    $View.GetType().InvokeMember("Close","InvokeMethod",$null,$View,$null)