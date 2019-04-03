
#Function Blocks
function Write-Log {
    Param(
        [string]$Data
    )

    #Calculate full path for log files
    $logPath = 'C:\amazon\TestLog.txt'
    
    #Calculate time stamp for log entry
    $date = get-date
    $timeStamp = $date.ToShortDateString() + " " + $date.ToLongTimeString() + ": "
    
    #Write data to log file
    $timeStamp + $data | Out-File $logPath -Append
}

#Main execution block

Set-AWSCredential -ProfileName RayC
$path = read-host "Enter path to files"

$pathexists = Test-Path -Path $path 
If ($pathexists -eq $false)
    { write-host 'Error with path!'
    write-log -data 'Error with path to files!'
    Break }
write-host 'hello world'
$vidOrpho = read-host "Enter 1 for Video or 2 for photos"
while ("1", "2" -notcontains $vidOrpho) {
        $vidOrpho = read-host "Enter 1 for Video or 2 for photos"
    }

if ($vidOrpho = 1 ) {

    $filetype = '*.mp4'
}
elseif ($vidOrpho = 2) {
    
    $filetype = '*.jpeg'
}

try {
    $files = Get-ChildItem -Path $path -File -Recurse -Include $filetype -ErrorAction Stop
}
catch {
    write-host 'Error with files load!'
    write-log -data 'Error with files load!'
    break
}



Write-host "Files to be uploaded: $($files.count)"
$total = $files.count 
write-host 'hello world'
foreach ($file in $files)

{
try {
    $mem = Get-ItemProperty -Path $file.FullName | Select-Object -ExpandProperty CreationTime 
}
catch {
    write-host "Error with file property for $($file.fullname)!"
    write-log -data "Error with file property for $($file.fullname)!"
}

[string]$keyyear =$mem.Year
$keyyear = $keyyear.Insert(4,"/")

$month = $mem.Month

switch ( $month )
{
    1 { $monthres = 'January'}
    2 { $monthres = 'Febuary'}
    3 { $monthres = 'March'}
    4 { $monthres = 'April'}
    5 { $monthres = 'May'}
    6 { $monthres = 'June'}
    7 { $monthres = 'July'}
    8 { $monthres = 'August'}
    9 { $monthres = 'September'}
    10 { $monthres = 'October'}
    11 { $monthres = 'November'}
    12 { $monthres = 'December'}
    Default { $monthres = 'Unknown'}
}

$keyresult = $keyyear + $monthres

Write-Progress -Activity "Copying data from '$path' to S3 Bucket" -Status "Copying File '$File'" -PercentComplete (($Position/$total)*100)
read-host 'press enter'
#Write-S3Object -BucketName bevcoatespower -file $file.FullName  -Key $keyresult
$Position++

}


