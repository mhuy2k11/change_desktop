$code = @' 
using System.Runtime.InteropServices; 
namespace Win32{ 
    
     public class Wallpaper{ 
        [DllImport("user32.dll", CharSet=CharSet.Auto)] 
         static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni) ; 
         
         public static void SetWallpaper(string thePath){ 
            SystemParametersInfo(20,0,thePath,3); 
         }
    }
 } 
'@
$changeDesktopFolder = Read-Host "Do you want to change the desktop folder? (Y/N)"
if ($changeDesktopFolder.ToUpper() -eq "Y") {
    $Desktopfolder = Read-Host "Enter your new desktop location"
    Add-Content -Path C:\Users\Public\Documents\cache.bat -Value "cd /d %userprofile% && rmdir Desktop && mklink /J Desktop $Desktopfolder"
    cmd.exe /c "cd /d c: && cd /d %userprofile%\.. && cd Public\Documents\ && cache.bat"
    Remove-Item "C:\Users\Public\Documents\cache.bat"
}
taskkill /f /im explorer.exe
Start-Process explorer
$changeWallpaper = Read-Host "Do you want to change the wallpaper? (Y/N)"  
if ($changeWallpaper.ToUpper() -eq "Y") {  
    $wallpaperPath = Read-Host "Enter the full path to the image file"  

    add-type $code 

    [Win32.Wallpaper]::SetWallpaper($wallpaperPath)

}
$changeIconPosition = Read-Host "Do you want to save the icon position? (Y/N)"  
if ($changeIconPosition.ToUpper() -eq "Y") {  
    $IconsavePath = Read-Host "Enter the full path to the icon save file (.dok)";
    DesktopOK.exe /save $IconsavePath ;
}
$changeDarkMode = Read-Host "Do you want to enable/disable dark mode? (Y/N)"  
    if ($changeDarkMode.ToUpper() -eq "Y") {   
        Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 0 -Force  
        Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Value 0 -Force  
        else {
            Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 1 -Force  
            Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Value 1 -Force  
        }
    } 

$SaveSettings = Read-Host "Do you want to export options? (Y/N)"
if ($SaveSettings.ToUpper() -eq "Y") {
    $fileName = Read-Host "Type the export file path (.ps1)"  
    Write-Host "Saving..."
    if ($changeDesktopFolder.ToUpper() -eq "Y") {
        Add-Content -Path "$fileName" -Value "cmd.exe /c `"cd /d %userprofile% && rmdir Desktop && mklink /J Desktop $Desktopfolder"
    }
    if ($changeWallpaper.ToUpper() -eq "Y") {
        Add-Content -Path "$fileName" -Value "`$code `= `@' `n $code `n`'@ `n add-type `$code `n [Win32.Wallpaper]::SetWallpaper(`"$wallpaperPath`") `n [Win32.Wallpaper]::SetWallpaper(`"$wallpaperPath`")"  
    }
    if ($changeIconPosition.ToUpper() -eq "Y") {
        Add-Content -Path "$fileName" -Value "`n DesktopOK.exe /load $IconsavePath;"
    }
    if ($changeDarkMode.ToUpper() -eq "Y") {
        Add-Content -Path "$fileName" -Value "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 0 -Force  `n Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Value 0 -Force `n taskkill /f /im explorer.exe `n Start-Process explorer.exe"
    } 
    if ($changeDarkMode.ToUpper() -eq "N") {
        Add-Content -Path "$fileName" -Value "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 1 -Force  `n Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Value 1 -Force `n taskkill /f /im explorer.exe `n Start-Process explorer.exe"
    }
}
timeout -1
