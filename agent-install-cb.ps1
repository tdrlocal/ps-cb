#Uncomment to integrate with SCCM
#$scriptpath = $MyInvocation.MyCommand.Path
#$scriptdir = Split-Path $scriptpath
#$installer="$scriptdir\CarbonBlackClientSetup.exe"

#Standalone checking and installation
$date = get-date -Format "dd-MM-yyyy"
$dir1="C:\Windows\CarbonBlack\cb.exe"
$installer="CarbonBlackClientSetup.exe"
$logfile = "C:\Windows\Logs\agent.log"

#Check if file exist, example latest version 6.1.9.81012
try {
    if([System.IO.File]::Exists($dir1)){
        Write-Host "Files exist! Checking versioning.."
        $get1=(get-item -Path $dir1).VersionInfo.ProductVersion -eq "6.1.9.81012"
        #Check for version
        if($get1)
        {
            Write-Host "Software is updated and latest"
            Add-Content -Path $logfile -Value "$date SUCCESS - agent Latest version"
        }
        else
        {
            Write-Host "Software is Outdated, initiating uninstallation.."        
            Start-Process -FilePath "C:\Windows\CarbonBlack\uninst.exe" -ArgumentList "/S" -Wait -PassThru
            Write-Host "Re-installing with the latest version.."        
            ##msiexec.exe /qn /i cbsetup.msi## Backup script
            Start-Process -FilePath $installer -ArgumentList "/S" -Wait -PassThru
            Add-Content -Path $logfile -Value "$date SUCCESS - reinstalled latest version"
        }
    }
        
    else{
        Write-Host "No file(s) existed, initiating installation"
        ##msiexec.exe /qn /i cbsetup.msi## Backup script
        Start-Process -FilePath $installer -ArgumentList "/S" -Wait -PassThru
        Add-Content -Path $logfile -Value "$date SUCCESS - Fresh installation for agent"
    }
}
catch {
    Add-Content -Path $logfile -Value "$date Installation failed - $($_.Exception.Message)"
}
