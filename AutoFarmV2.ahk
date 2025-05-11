#NoEnv
#SingleInstance, Force
#Include %A_ScriptDir%\FindText.ahk

; Setting scripting working state
SetWorkingDir, %A_ScriptDir%
setkeydelay, -1
setmousedelay, -1
setbatchlines, -1
SetTitleMatchMode 1
CoordMode, Pixel, Relative
CoordMode, Mouse, Relative

;=============== CURRENT VERSION ==================================

Current_version:="v1.0.0.0"  ; In github always create new release tag in this pattern

;==================================================================

repoOwner := "Kanekovisks"                  ; Change to your repository Owner Name
repoName := "AutoFarm-RangersX"             ; Your Repository Name

try
{
url := "https://api.github.com/repos/" repoOwner "/" repoName "/releases/latest"
WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
WinHttpReq.Open("GET", url)
WinHttpReq.Send()
data:=JsonToAHK(WinHttpReq.ResponseText)
latest_version := StrSplit(data["html_url"],"/")[8]
}



if (Current_version!=latest_version) && (latest_version)
    {
MsgBox 0x40044, New Update Available, Your current version   : %Current_version% `nNew version available   : %latest_version%`n`nDo you want to update ?

IfMsgBox Yes, {
    Try
    Run,% "https://github.com/" repoOwner "/" repoName "/releases/latest/AutoFarmV2.ahk"
    ; "https://github.com/" repoOwner "/" repoName "/releases/latest/download/your_file_to_download" ; directdownloadlink use UrlDownloadToFile

} Else IfMsgBox No, {

}
    }
return








JsonToAHK(json, rec := false) {
    static doc := ComObjCreate("htmlfile")
          , __ := doc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">")
          , JS := doc.parentWindow
    if !rec
       obj := %A_ThisFunc%(JS.eval("(" . json . ")"), true)
    else if !IsObject(json)
       obj := json
    else if JS.Object.prototype.toString.call(json) == "[object Array]" {
       obj := []
       Loop % json.length
          obj.Push( %A_ThisFunc%(json[A_Index - 1], true) )
    }
    else {
       obj := {}
       keys := JS.Object.keys(json)
       Loop % keys.length {
          k := keys[A_Index - 1]
          obj[k] := %A_ThisFunc%(json[k], true)
       }
    }
    Return obj
 }

;============================================================================================================================================

;==================================================================
; Essentials

Icon:= A_ScriptDir . "\gem.ico"
ConfigPath:= A_ScriptDir . "\config.ini"
Title:="Roblox"
Toggle:=0

if !FileExist(Icon)
{
	URLDownloadToFile, https://raw.githubusercontent.com/Kanekovisks/AutoFarm-RangersX/refs/heads/main/gem.ico?token=GHSAT0AAAAAADARAFCT2OWAISE5OVQIAZI62AYEOFA, gem.ico
	while !FileExist(Icon)
	{
		Sleep 1
	}
	Menu, Tray, Icon, %Icon%
}
else
	Menu, Tray, Icon, %Icon%

;==================================================================

;==================================================================
; GUI



;==================================================================

;==================================================================
; Ini File



;==================================================================


;============================================================================================================================================
return

GuiClose:
setkeydelay, 10
setmousedelay, 10
setbatchlines, 10
WinSet, AlwaysOnTop, Off, %Title%
ExitApp

; Closes the script
F4::
setkeydelay, 10
setmousedelay, 10
setbatchlines, 10
WinSet, AlwaysOnTop, Off, %Title%
ExitApp

; Reloads the script
F3::
WinSet, AlwaysOnTop, Off, %Title%
Reload
