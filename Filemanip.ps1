
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
#Set credentials and varibles
$position = 0
$vidOrpho =""
Set-AWSCredential -ProfileName RayC

#Collect path and vaidata
$path = read-host "Enter path to files"

$pathexists = Test-Path -Path $path 

If ($pathexists -eq $false)
    { write-host 'Error with path!'
    write-log -data 'Error with path to files!'
    Break }




#Select Video or Photo
while ("1", "2" -notcontains $vidOrpho) {
        $vidOrpho = read-host "Enter 1 for Video or 2 for photos"
    }

if ($vidOrpho -eq '1' ) {

    $filetype = '*.mp4'
    $bucket = 'bevvideo1'
}
elseif ($vidOrpho -eq '2') {
    
    $filetype = '*.jpg'
    $bucket = 'bevphoto1'
}
#Drill through file structure and collect vaid files
try {
    $files = Get-ChildItem -Path $path -File -Recurse -Include $filetype -ErrorAction Stop
}
catch {
    write-host 'Error with files load!'
    write-log -data 'Error with files load!'
    break
}


#Display file count to be uploaded. 
Write-host "Files to be uploaded: $($files.count)"
$total = $files.count 

#Extract lastWritetime (Modified Date) from file 
foreach ($file in $files)

{
try {
    $mem = Get-ItemProperty -Path $file.FullName | Select-Object -ExpandProperty LastWriteTime
}
catch {
    write-host "Error with file property for $($file.fullname)!"
    write-log -data "Error with file property for $($file.fullname)!"
}
#Extract year and add / at the end for AWS key reference. 
[string]$keyyear =$mem.Year
$keyyear = $keyyear.Insert(4,"/")

#Exract month and match the number 1-12 to month with a switch. 
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
#Add a / for AWS Key reference
$monthres = $monthres + '/'

# combine all varibles 
$keyresult = $keyyear + $monthres + $file.Name

#Command for upload to AWS key result loaded at this stage. 
try {
    Write-S3Object -BucketName $bucket -file $file.FullName  -Key $keyresult -ErrorAction Stop -Region eu-west-2
    write-log -data "Success $($file.FullName) uploaded to S3 as $($keyresult)"
}
catch {
    write-host "Error with file write to S3 for $($file.fullname)!"
    write-log -data "Error with file write to S3 for $($file.fullname)!"
}
#Writes progress to a gui display while the script runs. 
$Position++
Write-Progress -Activity "Copying data '$path' to S3 Bucket" -Status "Copying File '$File'" -PercentComplete (($Position/$total)*100)
write-host "File $($position) of $($total)"
Start-Sleep -Seconds 1

}

Write-host 'Upload completed'


