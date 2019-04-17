
#$eliminate1 = @("results.txt", "results1.txt")

#$eliminate2 = get-s3object -bucketname bevphoto1 | select-object key

#[string[]]$Feliminate = get-s3object -bucketname bevphoto1 | select-object key




#write-host "hello world"

#Get-ChildItem -Path C:\test -File -Recurse -Include *.txt -Exclude $eliminate2

#$eliminate2

#$eliminate3 = "2018/May/IMG_0830.JPG"

#$eliminate3.Split("/") | select -Last 1
<#
[string[]]$Feliminate = get-s3object -bucketname bevphoto1 | select-object key


[string[]]$Filearray1 = @()

write-host 'hello world'

foreach ($filename in $feliminate)

{
$fileshort = $filename.Split("/") | select -last 1
$fileshort = $fileshort.Substring(0,$fileshort.Length-1)

$fileArray1 += $fileshort

}
#>
[string[]]$Filearray1 = @()
[string[]]$Filearray2 = @()

$filearray1 = get-s3object -bucketname bevphoto1 | select-object key


foreach ($filename in $filearray1)

{
$fileshort = $filename.Split("/") | select -last 1
$fileshort = $fileshort.Substring(0,$fileshort.Length-1)

$fileArray2 += $fileshort

}

Get-ChildItem -Path "C:\LabSources\Tools" -File  -Recurse -Exclude $Filearray2