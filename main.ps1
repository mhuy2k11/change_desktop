$changeWallpaper = Read-Host "Do you want to change the wallpaper? (Y/N)"  

if ($changeWallpaper.ToUpper() -eq "Y") {  
    $wallpaperPath = Read-Host "Enter the full path to the image file"  

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

    add-type $code 

    #Apply the Change on the system 
    [Win32.Wallpaper]::SetWallpaper($wallpaperPath)

}
$changeIconPosition = Read-Host "Do you want to change the icon position? (Y/N)"  

if ($changeIconPosition.ToUpper() -eq "Y") {  
    $IconsavePath = Read-Host "Enter the full path to the icon save file (.dok)";
    DesktopOK.exe /save $IconsavePath ;
    DesktopOK.exe /load $IconsavePath ;
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
pause
