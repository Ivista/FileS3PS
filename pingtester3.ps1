foreach ($server in (Get-Content c:\pscode\servers.txt)) {
#skip blank lines
if (($server).length -gt 0) 
{        $pingresults = ping -n 2 $server

$server

     if ($pingresults -match "again") {

        write-host "This PC is not recognised on the network"

	
	$server >>C:\pingtester\UnRecognisedMachines.txt


               }
			   
			   



     if ($pingresults -match "Reply") {

        write-host "This PC is recognised on the network"
        $Dave = Get-WmiObject -ComputerName $server -Class Win32_Product


               }

      ElseIf ($pingresults -match "timed")  {

	write-host " Machine $hostname is not powered on"

	
	$server >>C:\pingtester\Notpoweredon.txt
}
} 
}