#------------------------------------------------------------
# Import files (Photo/video) from cards
# Author: Junod DUFORT
#--------------------------------------------------------------

# Retrieve current configuration
$myDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$ConfigFile = [xml](Get-Content settings.xml)

# Inside card path
$OlympusCardPath = $ConfigFile.settings.sources.OlympusCardPath
$CanonEosPath = $ConfigFile.settings.sources.CanonEosPath
$CanonHF10Path = $ConfigFile.settings.sources.CanonHF10Path
$AudioPathZoomH1 = $ConfigFile.settings.sources.AudioPathZoomH1
$AudioPathZoomH4n = $ConfigFile.settings.sources.AudioPathZoomH4n
$GoProPath = $ConfigFile.settings.sources.GoProPath

# Target paths
$rawDirectoryName = "raw"
$FotoOlympusTargetPath = $ConfigFile.settings.targets.FotoOlympusTargetPath
$FotoCanonEOS7dTargetPath = $ConfigFile.settings.targets.FotoCanonEOS7dTargetPath
$VideoCanonHF10TargetPath = $ConfigFile.settings.targets.VideoCanonHF10TargetPath
$AudioTargetPathZoomH1 = $ConfigFile.settings.targets.AudioTargetPathZoomH1
$AudioTargetPathZoomH4n = $ConfigFile.settings.targets.AudioTargetPathZoomH4n
$GoProTargetPath = $ConfigFile.settings.targets.GoProTargetPath

#---------------------------------------------------------------------
# Function treating the file import
#---------------------------------------------------------------------
function ImportFiles
{
	param($targetedDirectory, $cardDirectory, $rawExtension)
	
	"Targeted repository: " + $targetedDirectory
	
	$filesOnCard = dir -Recurse $cardDirectory | Where {$_.psIsContainer -eq $false}
	
	foreach($file in $filesOnCard)
	{
		$dateOfFile = $file.LastWriteTime.ToString("yyyy-MM-dd")
		$yearOfFile = $file.LastWriteTime.ToString("yyyy")
		$isJustCreated = $false
		$finalDir = $targetedDirectory + $yearOfFile + "\" + $dateOfFile + "\"
		
		# If raw file change target directory
		if($file.Extension -eq $rawExtension)
		{
			$finalDir = $finalDir + $rawDirectoryName + "\"
		}
		
		# If directory doesn't exists created it
		if(-not [system.IO.Directory]::Exists($finalDir))
		{
			"Create a new directory : " + $dateOfFile
			md $finalDir
			$isJustCreated = $true
		}
		
		# Check if directory is new and copy 
		if ($isJustCreated)
		{
			">>>>>>>>>>> copying " + $file.Name + " to " + $finalDir
			copy $file.FullName $finalDir
			"------- DONE -------"
			""
		}
		else
		{
			# verify that the file doesn't exist in the target rep
			if (-not [system.IO.File]::Exists($finalDir + $file.Name))
			{
				">>>>>>>>>>> copying " + $file.Name + " to " + $finalDir
				copy $file.FullName $finalDir	
				"------- DONE -------"
				""
			}
		}
	}
}


#------------------------------------
#
#  CANON EOS 7D
#
#------------------------------------

# Get files from the sd card
if ([System.IO.Directory]::Exists($CanonEosPath))
{		
	"-------------------------------------"
	"    CANON EOS FILE TREATMENT  "
	"-------------------------------------"
	""
	
	ImportFiles $FotoCanonEOS7dTargetPath  $CanonEosPath  ".CR2"
	
}
else
{
	"No card for CANON EOS 7D"
	""
}

#------------------------------------
#
#  OLYMPUS E 5
#
#------------------------------------

# Get files from the sd card
if ([System.IO.Directory]::Exists($OlympusCardPath))
{
	"-------------------------------------"
	"    OLYMPUS PHOTO FILE TREATMENT  "
	"-------------------------------------"
	""
	
	ImportFiles $FotoOlympusTargetPath  $OlympusCardPath  ".ORF"
}
else
{
	"No card for Olympus E-5"
	""
}


#------------------------------------
#
#  CANON HF10
#
#------------------------------------

# Get files from the sd card
if ([System.IO.Directory]::Exists($CanonHF10Path))
{
	"-------------------------------------"
	"    CANON HF10 VIDEO FILE TREATMENT  "
	"-------------------------------------"
	""
	
	ImportFiles $VideoCanonHF10TargetPath  $CanonHF10Path  ".MTS"
}
else
{
	"No card for Canon HF10"
	""
}


#------------------------------------
#
#  AUDIO ZOOMH1
#
#------------------------------------

# Get files from the sd card
if (Test-path -path $AudioPathZoomH1)
{
	"-------------------------------------"
	"    ZOOMH1 AUDIO FILE TREATMENT     "
	"-------------------------------------"
	""
	
	ImportFiles $AudioTargetPathZoomH1 $AudioPathZoomH1
}
else
{
	"No card for Audio ZOOMH1"
	""
}

#------------------------------------
#
#  AUDIO ZOOMH4N
#
#------------------------------------

# Get files from the sd card
if (Test-path -path $AudioPathZoomH4n)
{
	"-------------------------------------"
	"    ZOOMH4N AUDIO FILE TREATMENT     "
	"-------------------------------------"
	""
	
	ImportFiles $AudioTargetPathZoomH4n $AudioPathZoomH4n
}
else
{
	"No card for Audio ZOOMH4N"
	""
}

#------------------------------------
#
#  GOPRO
#
#------------------------------------

# Get files from the sd card
if (Test-path -path $GoProPath)
{
	"-------------------------------------"
	"    GOPRO FILE TREATMENT             "
	"-------------------------------------"
	""
	
	ImportFiles $GoProTargetPath $GoProPath ".MP4"
}
else
{
	"No card for GOPRO"
	""
}

""
"======================= END OF IMPORT ======================="	

