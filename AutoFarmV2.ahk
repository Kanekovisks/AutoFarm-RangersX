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
CoordMode, ToolTip, Relative

;============================================================================================================================================

;=======================================================================================================================================
; Essentials

;==================================================================
; Basic Variables

global Icon:= A_ScriptDir . "\gem.ico"
global ConfigPath:= A_ScriptDir . "\config.ini"
global Title:="Roblox"

if FileExist(Icon)
	Menu, Tray, Icon, %Icon%

;==================================================================

;==================================================================
; GUI

GuiConfig:
Gui, +AlwaysOnTop
Gui, Color, e6e1ea
Gui, Add, Tab3, 1, Farm

Gui, Add, Text, x22 y30 , Gamemode
Gui, Add, DropDownList, x22 y45 w110 h100 vModeSelected gSaveConfig, Story||Challenge|Ranger|Event
Gui, Add, CheckBox, x22 y75 vModeUpgrade gSaveConfig, Upgrade Units
Gui, Add, CheckBox, x22 y95 vModePortal gSaveConfig, Farm Portal

Gui, Add, Text, x132 y30 , Difficulty
Gui, Add, DropDownList, x132 y45 w110 h100 vModeDifficulty gSaveConfig, Normal||Hard|Nightmare|
Gui, Add, Text, x242 y30 , Stage
Gui, Add, DropDownList, x242 y45 w110 h200 vModeStage gSaveConfig, Voocha Village||Green Planet|Demon Forest|Leaf Village|Z City|Ghoul City
Gui, Add, Text, x352 y30 , Chapter
Gui, Add, DropDownList, x352 y45 w110 h170 vModeChapter gSaveConfig, 1||2|3|4|5|6|7|8|9|10|
Gui, Add, DropDownList, x352 y70 w110 h100 vModeType gSaveConfig, Next||Retry|

Gui, Add, Button, x21 y125 w80 h30 gLaunch, Start

; Checks config.ini
if FileExist(ConfigPath)
	Gosub, LoadConfig
else
{
	MsgBox, No configuration file found... `nOpening with default settings
	Gosub, SaveConfig
}

Gui, Show, AutoSize Center, Auto Farmer
	Gui, Submit, NoHide
return

;==================================================================

;==================================================================
; Toggle Macro

Launch:
if (WinExist(Title))
{
	Gui, Hide
	WinRestore
	WinActivate
	WinMove, %Title%, , 0, 0, 500, 500
	WinGetPos, winX, winY, winW, winH, %Title%
	global winX:=winX
	global winY:=winY
	global winW:=winW
	global winH:=winH
	global BasicMousePos:=[winW - 20, winH - 20]

	Sleep 10
	ToolTip, Macro Off, winW * 0.01, winH
	ToolTip, "P" - Start Macro | "F3" - Reload Macro | "F4" - Close Macro, winW * 0.3, winH,10
}
else
{
	Gui, Hide
	Run, roblox://placeID=72829404259339
	WinWait %Title%
	Goto, Launch
}

	KeyWait, p, D

Hotkey, p, ToggleMacro

ToggleMacro:
	if WinExist(Title)
	{
		WinSet, AlwaysOnTop, On, %Title%
		WinActivate
		ToolTip, Macro On, winW * 0.01, winH
		MouseMove, BasicMousePos[1], BasicMousePos[2], 10

		Gui, Hide
		Gosub, SaveConfig
		Gosub, LoadConfig
		Gosub, Calcs
		SetTimer, Farm, 1
		SetTimer, Timer, 1000
		SetTimer, Checker, 1000
	}
	else
		MsgBox, 0x40030, Error, Roblox Player not found
return

;==================================================================

;=======================================================================================================================================

;=======================================================================================================================================
; Ini File

;==================================================================
; Load File

; Loads settings from config.ini file
LoadConfig:
IniRead, lModeSelected, %ConfigPath%, Mode, ModeSelected
IniRead, lModeDifficulty, %ConfigPath%, Mode, ModeDifficulty
IniRead, lModeStage, %ConfigPath%, Mode, ModeStage
IniRead, lModeChapter, %ConfigPath%, Mode, ModeChapter
IniRead, lModeType, %ConfigPath%, Mode, ModeType
IniRead, lModeUpgrade, %ConfigPath%, Mode, ModeUpgrade
IniRead, lModePortal, %ConfigPath%, Mode, ModePortal

if (lModeSelected = "Story")
{
	GuiControl, Show, Difficulty
	GuiControl, Show, ModeDifficulty
	GuiControl, Show, Stage
	GuiControl, Show, ModeStage
	GuiControl, Show, Chapter
	GuiControl, Show, ModeChapter
	GuiControl, Show, Type
	GuiControl, Show, ModeType
	GuiControl, Hide, ModePortal
}
else if (lModeSelected = "Ranger")
{
	GuiControl, Hide, Difficulty
	GuiControl, Hide, ModeDifficulty
	GuiControl, Hide, Stage
	GuiControl, Hide, ModeStage
	GuiControl, Hide, Chapter
	GuiControl, Hide, ModeChapter
	GuiControl, Hide, Type
	GuiControl, Hide, ModeType
	GuiControl, Show, ModePortal
}
else
{
	GuiControl, Hide, Difficulty
	GuiControl, Hide, ModeDifficulty
	GuiControl, Hide, Stage
	GuiControl, Hide, ModeStage
	GuiControl, Hide, Chapter
	GuiControl, Hide, ModeChapter
	GuiControl, Hide, Type
	GuiControl, Hide, ModeType
	GuiControl, Hide, ModePortal
}

GuiControl, Choose, ModeSelected, %lModeSelected%
GuiControl, Choose, ModeDifficulty, %lModeDifficulty%
GuiControl, Choose, ModeStage, %lModeStage%
GuiControl, Choose, ModeChapter, %lModeChapter%
GuiControl, Choose, ModeType, %lModeType%
GuiControl,, ModeUpgrade, %lModeUpgrade%
GuiControl,, ModePortal, %lModePortal%
return

;==================================================================

;==================================================================
; Save File

; Save settings to config.ini file
SaveConfig:
Gui, Submit, NoHide

IniWrite, %ModeSelected%, %ConfigPath%, Mode, ModeSelected
IniWrite, %ModeDifficulty%, %ConfigPath%, Mode, ModeDifficulty
IniWrite, %ModeStage%, %ConfigPath%, Mode, ModeStage
IniWrite, %ModeChapter%, %ConfigPath%, Mode, ModeChapter
IniWrite, %ModeType%, %ConfigPath%, Mode, ModeType
IniWrite, %ModeUpgrade%, %ConfigPath%, Mode, ModeUpgrade
IniWrite, %ModePortal%, %ConfigPath%, Mode, ModePortal

if (ModeSelected = "Story")
{
	GuiControl, Show, Difficulty
	GuiControl, Show, ModeDifficulty
	GuiControl, Show, Stage
	GuiControl, Show, ModeStage
	GuiControl, Show, Chapter
	GuiControl, Show, ModeChapter
	GuiControl, Show, Type
	GuiControl, Show, ModeType
	GuiControl, Hide, ModePortal
}
else if (ModeSelected = "Ranger")
{
	GuiControl, Hide, Difficulty
	GuiControl, Hide, ModeDifficulty
	GuiControl, Hide, Stage
	GuiControl, Hide, ModeStage
	GuiControl, Hide, Chapter
	GuiControl, Hide, ModeChapter
	GuiControl, Hide, Type
	GuiControl, Hide, ModeType
	GuiControl, Show, ModePortal
}
else
{
	GuiControl, Hide, Difficulty
	GuiControl, Hide, ModeDifficulty
	GuiControl, Hide, Stage
	GuiControl, Hide, ModeStage
	GuiControl, Hide, Chapter
	GuiControl, Hide, ModeChapter
	GuiControl, Hide, Type
	GuiControl, Hide, ModeType
	GuiControl, Hide, ModePortal
}
return

;==================================================================

;=======================================================================================================================================

;=======================================================================================================================================
; Calculations
Calcs:

;==================================================================
; Basic Globals

global TimerS:=0
global TimerM:=0
global TimerH:=0

global ItemPortal:=0
global MouseMovementSpeed:=50
global Farming:=0
global InLobby:=0
global AllDone:=0
global Maxed:=0
global Upgrading:=0
global UpgUnit:=1
global CheckUnits:=1
global CheckChapter:=1
global Robux:=1

global Chapter1:=1
global Chapter2:=1
global Chapter3:=1

;==================================================================

;==================================================================
; Coords

; Roblox
global RobloxErrorPos:=[189,189,622,478]
global RobuxPos:=[702,37,745,78]

; Basics
global LeaderBoardPos:=[485,80,660,130]
global ChatPos:=[125,50,160,80]
global ConfigPos:=[15,590,40,615]

; Menu in Game
global WaitPos:=[353,329,464,371]
global StartPos:=[360,165,455,200]
global FarmingPos:=[141,395,543,454]
global GameEndedPos:=[121,156,543,219]

; Room Menu
global CreatePos:=[438,418,655,461]
global RoomPos:=[15,235,155,275]
global ALobbyMenuPos:=[485,500,545,520]
global LobbyPos:=[15,195,50,240]
global StartRoomPos:=[335,485,475,525]

; Menu in lobby area
global LobbyMenuPos:=[16,303,87,411]
global BossEventPos:=[400,375,515,405]
global GameEndedPos:=[140,397,545,410]
global LeavePos:=[8,326,160,387]

; Stages
global StagesPos:=[170,170,310,440]
global StagesCheckPos:=[195,160,660,310]
global RangerCheckPos:=[675,185,750,255]

; Difficulty
global ModePos:=[500,255,650,305]

; Chapter Pos
global ChPosX:=410
global ChPosY:=[215,260,320]

global Chapter1Pos:=[370,205,405,230]
global Chapter2Pos:=[370,265,450,285]
global Chapter3Pos:=[370,320,450,355]

; Upgrade Units
global Unit1Pos:=[730,183,788,264]
global Unit2Pos:=[730,263,788,342]
global Unit3Pos:=[730,344,788,424]

; Unit Slots
global UnitSlot1Pos:=[265,541,310,586]
global UnitSlot2Pos:=[314,541,358,586]
global UnitSlot3Pos:=[361,541,406,586]
global UnitSlot4Pos:=[409,541,454,586]
global UnitSlot5Pos:=[457,541,502,586]
global UnitSlot6Pos:=[505,541,550,586]

; Team Upgrade area
global TeamPos:=[726,180,787,447]
global BackPos:=[335,460,470,505]
global UpgradePos:=[35,375,130,405]

; Items
global ItemPos:=[119,209,573,400]
global StartPortalPos:=[50,332,198,374]

;==================================================================

;==================================================================
; Images

; Roblox Basics
global RobloxErrorTXT:="|<>FFFFFF@0.90$38.00000000000000000000000000000000000000000000001zzzw03zzzz01zzzzk0zzzzw0Tzzzz07zzzzk1zzzzw0zzzzz0Dzzzzk3zzzzw0zzzzz0Dzzzzk3zzzzw0zzzzz0Dzzzzk3zzzzw0zzzzz0Dzzzzk3zzzzw0zzzzz0Dzzzzk3zzzzw0zzzzz0Dzzzzk3zzzzw0zzzzz0Dzzzzk3zzzzw0zzzzz07zzzzk1zzzzw0Tzzzz03zzzzk0Tzzzw03zzzz007zzzk00000000000000000000000000000000000008"
global RobloxError2TXT:="|<>FFFFFF@0.90$133.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007zzzzzzzzzzzzzzzzzzzU0Tzzzzzzzzzzzzzzzzzzzk0Tzzzzzzzzzzzzzzzzzzzs0Tzzzzzzzzzzzzzzzzzzzw0Tzzzzzzzzzzzzzzzzzzzy0Dzzzzzzzzzzzzzzzzzzzz07zzzzzzzzzzzzzzzzzzzzU7zzzzzzzzzzzzzzzzzzzzk3zzzzzzzzzzzzzzzzzzzzs1zzzzzzzzzzzzzzzzzzzzw0zzzzzzzzzzzzzzzzzzzzy0Tzzzzzzzzzzzzzzzzzzzz0DzzzzzzzzzzzzzzzzzzzzU7zzzzzzzzzzzzzzzzzzzzk3zzzzzzzzzzzzzzzzzzzzs1zzzzzzzzzzzzzzzzzzzzw0zzzzzzzzzzzzzzzzzzzzy0Tzzzzzzzzzzzzzzzzzzzz0DzzzzzzzzzzzzzzzzzzzzU7zzzzzzzzzzzzzzzzzzzzk3zzzzzzzzzzzzzzzzzzzzs1zzzzzzzzzzzzzzzzzzzzw0zzzzzzzzzzzzzzzzzzzzy0Tzzzzzzzzzzzzzzzzzzzz0DzzzzzzzzzzzzzzzzzzzzU7zzzzzzzzzzzzzzzzzzzzk3zzzzzzzzzzzzzzzzzzzzs1zzzzzzzzzzzzzzzzzzzzw0zzzzzzzzzzzzzzzzzzzzy0Dzzzzzzzzzzzzzzzzzzzz07zzzzzzzzzzzzzzzzzzzzU3zzzzzzzzzzzzzzzzzzzzk0zzzzzzzzzzzzzzzzzzzzs0Dzzzzzzzzzzzzzzzzzzzw03zzzzzzzzzzzzzzzzzzzy00Dzzzzzzzzzzzzzzzzzzz0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000U"
global RobuxTXT:="|<>*96$24.zs7zzk3zz3kzw7sDkQC3Vs7VbU1t600MA00AA00AA7sAA7sAA7sAA7sAA7sAA7sAA00AC00Q700sXU1lVs7VsSS7w7sDz1Uzzk3zzwDzU"

; Basics
global LeaderBoardTXT:="|<>**50$12.wDyTrvvrRiCQCQRivrrvyTwDU"
global ChatTXT:="|<>**50$26.zzzzw000C0001U000M00060001U000M7zs61zy1U000M00060Dk1U7y0M0y060001U000M00070003zk0zny0Tk0kA0066000n0007U0U"
global WaitingPlayersTXT:="|<>AEAEAE@0.90$23.000000000007zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw"
global BackTXT:="|<>*119$29.0000000000000000000000000000000000000000000000000000000000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzk"
global LeaveTXT:="|<>ED0000@0.90$14.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz008"
global StartTXT:="|<>00D000@0.90/00FF00@0.90$11.zzzzzzzzzzzzzzzzzzzzzzU"
global ConfigTXT:="|<>*132$10.wznm400A9tbYA008HnzDU"

; Units
global UnitSlotTXT:="|<>E2E4EA@0.90$38.007zk0001zw0000Tz00007zk0001zw0000Tz00007zk0001zw0000Tz00007zk0000Tw03zw1zyzzzk1zvzzzzzzTzzzzzrzzzzzxzzzzzzTzzzzzrzzzzzxzzzzzzTzzzzzrzzzzzxzzzzzzTzzzzzrTzzzzxc"
global UnitStatsTXT:="|<>17A9EC@0.90$21.zzzzzzzzzzzzzzzzzw"

; Upgrades
global UpgradeMaxTXT:="|<>9E9E9E@0.90/7B7B7B@0.90$5.zzzzzzzzzzzy"
global Upgrade1TXT:="|<>9FF786@0.90$87.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw"
global Upgrade2TXT:="|<>70AD5E@0.90$78.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzU"
global Upgrade3TXT:="|<>436438@0.90$80.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzs"

; Modes
global RangerCheckTXT:="|<>00BEFF@0.90$36.000800600Q00Ds0Q00Dz0S00Dzyz00DzzzU0Dzzzk0Tzzzs0Tzzzw0Tzzzw0Tzzzy0zzzzz0zDzzzUyDzzzkwDzzzks7zkTsk7w0Tw1702Dy301zDz3UDzDz7VzzDs7zzz7U3zzz001zzzU00zzzU00TzzU00DzzU007zzk003zzk003zzk001zzs0U"
global RangerCooldownTXT:="|<>FF2525@0.90$2.y"
global BossEventTXT:="|<>FF0000@0.90/A60000@0.90$14.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzy"

if (ModeDifficulty = "Normal") ; Normal Mode
	global DifficultyTXT:="|<>0DA300@0.90$8.zzzzzzzzzzy"
if (ModeDifficulty = "Hard") ; Hard Mode
	global DifficultyTXT:="|<>A70000@0.90$10.zzzzzzzzzzzzzzzU"
if (ModeDifficulty = "Nightmare") ; Nightmare Mode
	global DifficultyTXT:="|<>AD00EC@0.90$9.zzzzzzzzzzzzU"

; Lobby
global AreasTXT:="|<>*56$14.w3y0T03U0MG4004010U00U4MS703k0y0TkDy7zVy"
global PlayTXT:="|<>EC0002@0.90$6.zzznnnzzzU"
global LobbyTXT:="|<>*93$11.kT0C0A0800001060D0Tkk"
global CreateTXT:="|<>00FF00@0.90$9.zzzzzzzzzzzzzw"
global LeaveRoomTXT:="|<>FF0000@0.95$11.zzzzzzzzzzzzzzzzzzzzzzzy0000000000000000000001"

; Items
global PortalTXT:="|<>FAFAFB@0.95$19.00000000U03k03k03y01zs0zw0Ty0Dy07z01zU0Tk0zk0DU0000001"
global UseItemTXT:="|<>54CF00@0.90$14.000000000Dzzzzzzzzzzzzzzzzzzzzzzzzz0000000008"
global SearchItemTXT:="|<>3A405F@0.95$11.3sDsstUn1a7/wzna608"

; In Game
global GameEndedTXT:="|<>*194$81.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzs0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw"
global RetryTXT:="|<>ECD700@0.90$10.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzk00000002"
global NextTXT:="|<>5AD200@0.90$12.000000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz0000000000000000U"
global LeaveGameTXT:="|<>C80000@0.90$14.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzU"
global APlayOnTXT:="|<>91F302@0.90$4.zzy"
global APlayOffTXT:="|<>E62200@0.90$4.zzy"
global GameEndedTXT:="|<>*1$396.U0000000TzzzzzzzzU0000000Dzzzzzzzz00000000TzzzzzzzzU0000000TzzzzzzU0000000Dzzzzzzzzk00000007zzzzzzzzU0000000DzzzzzzzzU0000000Dzzzzzzk00000007zzzzzzzzs00000007zzzzzzzzk0000000Dzzzzzzzzk00000007zzzzzzs00000003zzzzzzzzw00000003zzzzzzzzs00000007zzzzzzzzs00000003zzzzzzU"
global TeamBackTXT:="|<>8A8A8A@0.90/696969@0.90$9.zzzzzzzzzzzzzzzzzzzzzzzzU"

;==================================================================

;==================================================================
; Modes

if (ModeType = "Retry")
	global Retry:=1
if (ModeType = "Next")
	global Retry:=0

if (ModeSelected = "Challenge")
	global Retry:=1
if (ModeSelected = "Ranger")
	global Retry:=0
if (ModeSelected = "Event")
{
	global Retry:=1
	global ModeUpgrade:=1
}
;==================================================================

;==================================================================
; Global

global ModeSelected:=ModeSelected
global ModeDifficulty:=ModeDifficulty
global ModeStage:=ModeStage
global ModeChapter:=ModeChapter
global ModeType:=ModeType
global ModeUpgrade:=ModeUpgrade
global ModePortal:=ModePortal

;==================================================================

;==================================================================
; Stages List

if (ModeSelected = "Ranger")
	global StageNum:=1
	global StageCount:=6

StagesList:
if (StageNum = 1)
{
	global ModeStage:="Voocha Village"
	global ActCount:=3
}
if (StageNum = 2)
{
	global ModeStage:="Green Planet"
	global ActCount:=3
}
if (StageNum = 3)
{
	global ModeStage:="Demon Forest"
	global ActCount:=3
}
if (StageNum = 4)
{
	global ModeStage:="Leaf Village"
	global ActCount:=3
}
if (StageNum = 5)
{
	global ModeStage:="Z City"
	global ActCount:=3
}
if (StageNum = 6)
{
	global ModeStage:="Ghoul City"
	global ActCount:=5
}

if (ModeStage = "Voocha Village")
{
	global StageNum:=1
	global StageCheckTXT:="|<>*106$153.zzzzzzU00000Dzk0000001zzzzzzzzzw000003zw0000000Dzzzzzzzzzk00000zzU0000001zzzzzzzzzzk00007zw0000000Dzzzzzzzzzy00000bz00000001zzzw"
	global StageTXT:="|<>*114$128.31zzzzzzw03tnsDkDzzzzlUTzzzzzzU1yw01w3zzzzzzzzzrzzzw01jU000zzzzzzzzzsTzzzU0Ts000Dzzzzzzzzzyzzzk07z0007zzzzzzzzzzzzzw01zk00DzzzzzzyDzzzzzzAATw00DzzzzzzzzzzzzzzzX7zU0Tzzzzzzzzzzzzzzztnjs3zzzzzzzzzzzzzzzzyAzy1zzzzzzzzzzzzzzzzz0TzUTzzzzzzzzzzzzzzzzbzzy7zzzzzzzU"
}

if (ModeStage = "Green Planet")
{
	global StageNum:=2
	global StageCheckTXT:="|<>*111$148.zz000zzw0000003zs000Dzzzzzw003zzk000000DzU000zzzzzzk00Dzz0000000zw0003zzzzzz000zzw0000007zk000Dzzzzzw001bzU000000Ty0000zzzzzzk0007w0000003zs0003zzzzzz0000DU000000TzU000Dzzzy"
	global StageTXT:="|<>*108$129.zzvzrzU000102zszzzzzzzzxzyzw000000Hk7zzzzzzzzzzzzU0000023Uzzzzzzzzjzzzw00Tk000T3zzzzzzzzzzzzU03zs003kTzzzzzzzzVzzw00zzU00S3zzTzzzzzw7zzkFDzy000kzzzzzzzzz3zzy03zzk7U07zzzzzzzzlTzzw0Dzz1w03zzzzzzzzzzzzzU0zzzzU7zzzzzzzzzzzzzsQ7yTzw1zzzzzzzzzzzzzzbUrlzzkDzzzzzzzzzzzzzzzyQ7zz1zzzzzzzw"
}

if (ModeStage = "Demon Forest")
{
	global StageNum:=3
	global StageCheckTXT:="|<>*46$152.zzzs00000000000Dzzzzzzzzzzzzy000000000003zzzzzzzzzzzzy000000000000zzzzzzzzzzzzzU00000000000Dzzzzzzzzzzzzw000000000003zzzzzzzzzy"
	global StageTXT:="|<>*53$128.zzzzzs3zz20vy00003Uz1zzzzzy3zztkDzUT020zzkzzzzzzURzyQ3zs7s0zzzzzzzzzzs7TzbXzy1zkTzzzzzzzzzz0rzzxzzUTz3zzzzyzzzzzkBzzzzzzzzvzzzzzzzzzztzzzzzzzzzywzzzzrzzzjyzzzzzzzzzzWzzzzxzzzzvDzzzzzzzzztzzzzzTzzzzzzzzzzzzzzzzzzbzzzzvzzzzzzzzzzzzzzzkzzzzzzzzzzzzzzzzzzzzwDzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzwzzzzzzy"
}

if (ModeStage = "Leaf Village")
{
	global StageNum:=4
	global StageCheckTXT:="|<>*42$151.00001k1k000000000003zzzzzU0000Q0s000000000001zzvzzk000070C000000000000zztzzs00000k3U00000000000Tzxzzw00000A1s00000000000bzyzzz"
	global StageTXT:="|<>*72$129.y7wTw000000001zzzzzzU7kzXzU00000000LzzzxsE0y7wzk000000002xzznT287kzlz000000000P7zwTzzlyDzDw00000000E8zz3zrw7zzzzU00011VU603zyTzzzzxzzz0000M3w0k8Dwzzzzzzzzzs3U03Vw0CF0TUzzzwzzzzzUy01SD00k87w7zzzrzzzzyDk0Tzs0610nVzzzzzzzzzXsk3gDbxy8CQTzzzzzzzztz7kxtwy1N7nzzzzztyDzwTsLu7wv0ERDzvzzzy11zznv2zUDzPG3tzszzzzm8TzzzzLz1zxzyTzyTzzzzzXzzzz9Tz1zzz9xzjzzzzU"
}

if (ModeStage = "Z City")
{
	global StageNum:=5
	global StageCheckTXT:="|<>*96$158.zzzw0A0000000001zzzzzzzzzzzzzz070000000000zzzzzzzzzzzzzzk1k000000000Tzzzzzzzzzzzzzw0Q000000000Dzzzzzzzzzzzzzz070000000001zzzzzzzzzzzzzzk1k000000000DzzzzzzzzzzU"
	global StageTXT:="|<>*98$130.7zzzkzy00007zzzzyDns00zzzsk7s00007zzzzlzbk03zzzXUDU0000Dzzzy7zzk3Dzzy1UC00000zzzw0Tzzhxzzzs3UwU0003zzzk0TzzwrzzzU70k0000Dzzq01zzznTzzy27100000zzy007zzzxzzzs0C300007zy01zzzzzrzzzk0CA0007zzk0TzzzzsTzzzk4Dk0DyTzw01xzzzzXzzzvyoT0Dztzzk0Dzzzzzzzzy/tow0zzbzw00zzzzzzzzzwbrzk3zyTbU03zzzzzzzzzyHzz00ztzW00Dzzzzzzzzzx/zw07zbz800zzzzzzzzzzyjzkkTyTzU03zzzzzzzzzzzzzlVzzzw00Dzzzzzzzzzzzzzk3zzzs00zzzzzzU"
}

if (ModeStage = "Ghoul City")
{
	global StageNum:=6
	global StageCheckTXT:="|<>*33$162.zzz00000000CDzs00Dzzzzzzzzzzzs00s000000Dzs00Tzzzzzzzzzzzs03w000000Dzk00zzzzzzzzzzzzs03w000000Dzs00zzzzzzzzzzzzw0Dw000000Dzs01zzzzzzzzzzzzw0Tw000000Dzw01zzzzzzzzzzzzy7zw000000Tzs00zzzzzzzzzzU"
	global StageTXT:="|<>*49$131.S07bDzzzw3jzzzzzzzzzzkw03yzzzzy4TzznzzzzzzzxsS1tzzzzzsyTzbs3zzzzzvUzznzzU7zlUTzDU3zzzzzr3zzbzzk1zm0TyDbzzzzzzg7zzzzzzzzY0DwPDzzzzzzMDzzzzw1zz00Dkq0DzzzzzkTzzzzw3zyE0DVw0Czzzzx07zzzzzzzsU0T1s0Rzzzzs2DzzzzzzzlU1z3k0tzzzzkDzzzsTzzza7zy3WxnzzzzUTzzztztTzDzzwDLlbzzzz01zzzzzkiTTzzsSzXjzzzy03zzzzzZsyzzzlrz7zzzzxzzzzzzyDxxzzzbjz6Tzzzvzzzzzww7zzzzzTzw0zzzzs"
}

;==================================================================

return

;=======================================================================================================================================

;=======================================================================================================================================
; Functions

;======================================================================================
; Roblox

ErrorCheck()
{
	if (RobloxError2Img:=FindText(REX2, REY2, RobloxErrorPos[1], RobloxErrorPos[2], RobloxErrorPos[3], RobloxErrorPos[4], 0, 0, RobloxError2TXT))
	{
		FindText().Click(REX2, REY2, MouseMovementSpeed, "L",,1)
		global InLobby:=0
		global Farming:=0

		ErrorS:=0
		ErrorM:=2

		Loop
		{
			Sleep 1000
			ErrorS--
			if (ErrorS <= 0)
			{
				ErrorS:=60
				ErrorM--
			}
			if (ErrorM < 0)
				break

			ToolTip, Waiting %ErrorM%m %ErrorS%s, winW * 0.01, winH + 25,2
		}
		Run, roblox://placeID=72829404259339
		ToolTip,,,,12
		ToolTip,,,,5
		ToolTip,,,,4
		ToolTip, Roblox, winW * 0.01, winH + 50,3
		ToolTip, Joining Game, winW * 0.01, winH + 25,2
		MouseMove, winW, winH, 10
	}

	else if (RobloxErrorImg:=FindText(REX, REY, RobloxErrorPos[1], RobloxErrorPos[2], RobloxErrorPos[3], RobloxErrorPos[4], 0, 0, RobloxErrorTXT))
	{
		global InLobby:=0
		global Farming:=0
		Run, roblox://placeID=72829404259339
		ToolTip,,,,12
		ToolTip,,,,5
		ToolTip,,,,4
		ToolTip, Roblox, winW * 0.01, winH + 50,3
		ToolTip, Joining Game, winW * 0.01, winH + 25,2
		MouseMove, winW, winH, 10
	}

	if (RobuxImg:=FindText(RBX, RBY, RobuxPos[1], RobuxPos[2], RobuxPos[3], RobuxPos[4], 0, 0, RobuxTXT))
	{
		global InLobby:=0
		global Farming:=0
		if (Robux)
		{
			Robux:=0
			Run, roblox://placeID=72829404259339
			ToolTip,,,,12
			ToolTip,,,,5
			ToolTip,,,,4
			ToolTip, Roblox, winW * 0.01, winH + 50,3
			ToolTip, Joining Game, winW * 0.01, winH + 25,2
			MouseMove, winW, winH, 10
		}
	}
	return
}

;======================================================================================

;======================================================================================
; Unit Slots Check

UnitSlotsCheck()
{
	if (UnitSlotImg:=FindText(USX, USY, UnitSlot1Pos[1], UnitSlot1Pos[2], UnitSlot1Pos[3], UnitSlot1Pos[4], 0, 1, UnitSlotTXT))
	{
		global UnitSlot1:=0
		global Unit1:="Unit 1: None"
	}
	else
	{
		global UnitSlot1:=1
		global Unit1:="Unit 1: Ok"
	}

	if (UnitSlotImg:=FindText(USX, USY, UnitSlot2Pos[1], UnitSlot2Pos[2], UnitSlot2Pos[3], UnitSlot2Pos[4], 0, 1, UnitSlotTXT))
	{
		global UnitSlot2:=0
		global Unit2:="Unit 2: None"
	}
	else
	{
		global UnitSlot2:=1
		global Unit2:="Unit 2: Ok"
	}

	if (UnitSlotImg:=FindText(USX, USY, UnitSlot3Pos[1], UnitSlot3Pos[2], UnitSlot3Pos[3], UnitSlot3Pos[4], 0, 1, UnitSlotTXT))
	{
		global UnitSlot3:=0
		global Unit3:="Unit 3: None"
	}
	else
	{
		global UnitSlot3:=1
		global Unit3:="Unit 3: Ok"
	}

	if (UnitSlotImg:=FindText(USX, USY, UnitSlot4Pos[1], UnitSlot4Pos[2], UnitSlot4Pos[3], UnitSlot4Pos[4], 0, 1, UnitSlotTXT))
	{
		global UnitSlot4:=0
		global Unit4:="Unit 4: None"
	}
	else
	{
		global UnitSlot4:=1
		global Unit4:="Unit 4: Ok"
	}

	if (UnitSlotImg:=FindText(USX, USY, UnitSlot5Pos[1], UnitSlot5Pos[2], UnitSlot5Pos[3], UnitSlot5Pos[4], 0, 1, UnitSlotTXT))
	{
		global UnitSlot5:=0
		global Unit5:="Unit 5: None"
	}
	else
	{
		global UnitSlot5:=1
		global Unit5:="Unit 5: Ok"
	}

	if (UnitSlotImg:=FindText(USX, USY, UnitSlot6Pos[1], UnitSlot6Pos[2], UnitSlot6Pos[3], UnitSlot6Pos[4], 0, 1, UnitSlotTXT))
	{
		global UnitSlot6:=0
		global Unit6:="Unit 6: None"
	}
	else
	{
		global UnitSlot6:=1
		global Unit6:="Unit 6: Ok"
	}

	ToolTip, %Unit1%`t%Unit4%`t`n%Unit2%`t%Unit5%`t`n%Unit3%`t%Unit6%`t, winW * 0.37, winH + 25,12
	global CheckUnits:=0

	return
}

;======================================================================================

;======================================================================================
; Camera Fix

CameraFix()
{
	if (PlayImg:=FindText(LMX:="wait", LMY:=3, LobbyMenuPos[1], LobbyMenuPos[2], LobbyMenuPos[3], LobbyMenuPos[4], 0, 0, PlayTXT))
	{
		ToolTip, Play Found, winW * 0.01, winH + 25,2
		FindText().Click(LMX, LMY, MouseMovementSpeed, "L",,1)
		Sleep 1000
	}

	if (LeaveImg:=FindText(LVX:="wait", LVY:=3, LeavePos[1], LeavePos[2], LeavePos[3], LeavePos[4], 0, 0, LeaveTXT))
	{
		ToolTip, Camera Fixed!, winW * 0.01, winH + 25,2
		FindText().Click(LVX, LVY, MouseMovementSpeed, "L",,1)
		Sleep 1000
	}

	return
}

;======================================================================================

;======================================================================================
; Essentials

Essentials()
{
	if (LeaveImg:=FindText(LVX, LVY, LeavePos[1], LeavePos[2], LeavePos[3], LeavePos[4], 0, 0, LeaveTXT))
	{
		FindText().Click(LVX, LVY, MouseMovementSpeed, "L",,1)
		Sleep 500
	}

	if (LeaderBoardImg:=FindText(LBX, LBY, LeaderBoardPos[1], LeaderBoardPos[2], LeaderBoardPos[3], LeaderBoardPos[4], 0, 0.8, LeaderBoardTXT))
	{
		FindText().Click(LBX, LBY, MouseMovementSpeed, "L",,1)
		Sleep 500
	}

	if (WaitingPlayersImg:=FindText(WX, WY, WaitPos[1], WaitPos[2], WaitPos[3], WaitPos[4], 0, 0, WaitingPlayersTXT))
	{
		FindText().Click(WX, WY, MouseMovementSpeed, "L",,1)
		Sleep 500
	}

	if (ChatImg:=FindText(CHX, CHY, ChatPos[1], ChatPos[2], ChatPos[3], ChatPos[4], 0, 0, ChatTXT))
	{
		FindText().Click(CHX, CHY, MouseMovementSpeed, "L",,1)
		Sleep 500
	}
}

;======================================================================================

;======================================================================================
; Instance Check

InstanceCheck()
{
	if (StartImg:=FindText(SX, SY, StartPos[1], StartPos[2], StartPos[3], StartPos[4], 0, 0, StartTXT))
	{
		FindText().Click(SX, SY, MouseMovementSpeed, "L",, 1)
		ToolTip, In Game, winW * 0.01, winH + 50,3
		global Farming:=1
		global InLobby:=0
		global Robux:=1
		Sleep 1000
	}

	if (APlayOnImg:=FindText(ALX, ALY, ALobbyMenuPos[1], ALobbyMenuPos[2], ALobbyMenuPos[3], ALobbyMenuPos[4], 0, 0, APlayOnTXT))
	{
		ToolTip, In Game, winW * 0.01, winH + 50,3
		global Farming:=1
		global InLobby:=0
		global Robux:=1
	}

	if (LobbyImg:=FindText(LX, LY, LobbyPos[1], LobbyPos[2], LobbyPos[3], LobbyPos[4], 0, 0, LobbyTXT))
	{
		ToolTip, In Lobby, winW * 0.01, winH + 50,3
		global Farming:=0
		global InLobby:=1
		global Robux:=1
	}
}

;======================================================================================

;======================================================================================
; Stage Select

StageSelect()
{
	Selection:	
	MouseMove, winX + 167, winY + 300, 10
	Sleep 100
	Loop, 10
		Send {WheelUp}

	if (StageNum >= 5)
	{
		Sleep 100
		Loop, 10
			Send {WheelDown}
		Sleep 200
	}

	MouseMove, 0, 200, MouseMovementSpeed, R

	if (StageImg:=FindText(STGX:="wait", STGY:=5, StagesPos[1], StagesPos[2], StagesPos[3], StagesPos[4], 0, 0, StageTXT))
		FindText().Click(STGX, STGY, MouseMovementSpeed,"L",,1)

	if (StageCheckImg:=FindText(STGCX:="wait", STGCY:=5, StagesCheckPos[1], StagesCheckPos[2], StagesCheckPos[3], StagesCheckPos[4], 0, 0, StageCheckTXT))
		ToolTip, %ModeStage%, winW * 0.80, winH + 25,4

	if (ok:=FindText(LBX, LBY, LeaderBoardPos[1], LeaderBoardPos[2], LeaderBoardPos[3], LeaderBoardPos[4], 0, 0.8, LeaderBoardTXT))
		FindText().Click(LBX, LBY, MouseMovementSpeed, "L",,1)

	if (ModeSelected = "Ranger")
	{
		global Retry:=0

		if (RangerCheckImg:=FindText(RCX:="wait", RCY:=5, RangerCheckPos[1], RangerCheckPos[2], RangerCheckPos[3], RangerCheckPos[4], 0, 0, RangerCheckTXT))
		{
			Sleep 500

			Check:
			if (RangerCooldownImg:=FindText(CX1, CY1, Chapter1Pos[1], Chapter1Pos[2], Chapter1Pos[3], Chapter1Pos[4], 0, 0, RangerCooldownTXT) && Chapter1)
			{
				ToolTip, In Cooldown, winW * 0.01, winH + 25,2
				global Chapter1:=0
				Goto, Check
			}

			else if (!RangerCooldownImg:=FindText(CX1, CY1, Chapter1Pos[1], Chapter1Pos[2], Chapter1Pos[3], Chapter1Pos[4], 0, 0, RangerCooldownTXT) && !Chapter1)
			{
				ToolTip, Act 1 Playable, winW * 0.01, winH + 25,2
				FindText().Click(ChPosX, ChPosY[1], MouseMovementSpeed,"L",,1)
				global ModeChapter:=1
				return
			}

			if (RangerCooldownImg:=FindText(CX2, CY2, Chapter2Pos[1], Chapter2Pos[2], Chapter2Pos[3], Chapter2Pos[4], 0, 0, RangerCooldownTXT) && Chapter2)
			{
				ToolTip, In Cooldown, winW * 0.01, winH + 25,2
				global Chapter2:=0
				Goto, Check
			}
			else if (!RangerCooldownImg:=FindText(CX2, CY2, Chapter2Pos[1], Chapter2Pos[2], Chapter2Pos[3], Chapter2Pos[4], 0, 0, RangerCooldownTXT) && !Chapter2)
			{
				ToolTip, Act 2 Playable, winW * 0.01, winH + 25,2
				FindText().Click(ChPosX, ChPosY[2], MouseMovementSpeed,"L",,1)
				global ModeChapter:=2
				return
			}

			if (RangerCooldownImg:=FindText(CX3, CY3, Chapter3Pos[1], Chapter3Pos[2], Chapter3Pos[3], Chapter3Pos[4], 0, 0, RangerCooldownTXT) && Chapter3)
			{
				global Chapter3:=0
				if (StageNum < StageCount)
				{
					StageNum++
					Gosub, StagesList
				}
				else
				{
					global StageNum:=1
					global AllDone:=1
					ToolTip, All Stages Done!, winW * 0.01, winH + 25,2					
					Gosub, StagesList
				}

				global Chapter1:=1
				global Chapter2:=1
				global Chapter3:=1

				if (AllDone && ModePortal)
				{
					global ModeUpgrade:=1
					return
				}
				
				Goto, Selection
			}

			else if (!RangerCooldownImg:=FindText(CX3, CY3, Chapter3Pos[1], Chapter3Pos[2], Chapter3Pos[3], Chapter3Pos[4], 0, 0, RangerCooldownTXT) && !Chapter3)
			{
				ToolTip, Act 3 Playable, winW * 0.01, winH + 25,2
				FindText().Click(ChPosX, ChPosY[3], MouseMovementSpeed,"L",,1)
				global ModeChapter:=3
			}
		}
	}

	return
}

;======================================================================================

;======================================================================================
; Chapter Select

ChapterSelect()
{
	MouseMove, winX + 345, winY + 275, 10

	Loop, 10
		Send {WheelUp}

	Sleep 350

	if (ModeChapter = 1)
		FindText().Click(ChPosX, ChPosY[1], MouseMovementSpeed,"L",,1)

	if (ModeChapter = 2)
		FindText().Click(ChPosX, ChPosY[2], MouseMovementSpeed,"L",,1)

	if (ModeChapter = 3)
		FindText().Click(ChPosX, ChPosY[3], MouseMovementSpeed,"L",,1)

	if (ModeChapter >= 4)
	{
		Send {WheelDown}
		Sleep 350

		if (ModeChapter = 4)
			FindText().Click(ChPosX, ChPosY[2], MouseMovementSpeed, "L",,1)

		if (ModeChapter = 5)
			FindText().Click(ChPosX, ChPosY[3], MouseMovementSpeed, "L",,1)
	}

	if (ModeChapter >= 6)
	{
		Send {WheelDown}
		Sleep 350

		if (ModeChapter = 6)
			FindText().Click(ChPosX, ChPosY[1], MouseMovementSpeed, "L",,1)

		if (ModeChapter = 7)
			FindText().Click(ChPosX, ChPosY[2], MouseMovementSpeed, "L",,1)
	}

	if (ModeChapter >= 8)
	{
		Send {WheelDown}
		Sleep 350

		if (ModeChapter = 8)
			FindText().Click(ChPosX, ChPosY[1], MouseMovementSpeed, "L",,1)

		if (ModeChapter = 9)
			FindText().Click(ChPosX, ChPosY[2], MouseMovementSpeed, "L",,1)

		if (ModeChapter = 10)
			FindText().Click(ChPosX, ChPosY[3], MouseMovementSpeed, "L",,1)
	}
	return
}

;======================================================================================

;======================================================================================
; Portal Farm

PortalFarm()
{
	if (LeaveRoomImg:=FindText(LVRX:="wait", LVRY:=3, CreatePos[1], CreatePos[2], CreatePos[3], CreatePos[4], 0, 0, LeaveRoomTXT))
	{
		Sleep 200
		ToolTip, Leave Found, winW * 0.01, winH + 25,2
		FindText().Click(LVRX, LVRY, MouseMovementSpeed,"L",,1)
		Sleep 1000
	}
	
	if (LeaveImg:=FindText(LVX:="wait", LVY:=3, LeavePos[1], LeavePos[2], LeavePos[3], LeavePos[4], 0, 0, LeaveTXT))
	{
		Sleep 200
		ToolTip, Leave Found, winW * 0.01, winH + 25,2
		FindText().Click(LVX, LVY, MouseMovementSpeed,"L",,1)
		Sleep 1000
	}
	
	if (LobbyImg:=FindText(LX:="wait", LY:=3, LobbyPos[1], LobbyPos[2], LobbyPos[3], LobbyPos[4], 0, 0, LobbyTXT))
	{
		if (PlayImg:=FindText(LMX:="wait", LMY:=3, LobbyMenuPos[1], LobbyMenuPos[2], LobbyMenuPos[3], LobbyMenuPos[4], 0, 0, PlayTXT))
		{
			ToolTip, Opening Items, winW * 0.01, winH + 25,2
			FindText().Click(LMX, LMY - 39, MouseMovementSpeed, "L",,1)
			Sleep 1000
		}
	}

	if (SearchItemImg:=FindText(SRCX:="wait", SRCY:=3, ItemPos[1], ItemPos[2], ItemPos[3], ItemPos[4], 0, 0, SearchItemTXT))
	{
		ToolTip, Searching for Portals, winW * 0.01, winH + 25,2
		FindText().Click(SRCX + 50, SRCY, MouseMovementSpeed,"L",,1)
		Sleep 200
		Send {CtrlDown}{a}
		Sleep 200
		Send {Ctrl up}
		Sleep 200
		Send {BackSpace}
		Sleep 200
		SendRaw portal
		Sleep 1000
	}

	if (PortalImg:=FindText(PTLX:="wait", PTLY:=3, ItemPos[1], ItemPos[2], ItemPos[3], ItemPos[4], 0, 0, PortalTXT))
	{
		ToolTip, Portal Found, winW * 0.01, winH + 25,2
		FindText().Click(PTLX, PTLY, MouseMovementSpeed,"L",,1)
		Sleep 500

		if (UseItemImg:=FindText(UIX:="wait", UIY:=3, ItemPos[1], ItemPos[2], ItemPos[3], ItemPos[4], 0, 0, UseItemTXT))
		{
			Sleep 500
			ToolTip, Using Portal, winW * 0.01, winH + 25,2
			FindText().Click(UIX, UIY, MouseMovementSpeed,"L",,1)
		}

		if (StartRoomImg:=FindText(SPX:="wait", SPY:=5, StartPortalPos[1], StartPortalPos[2], StartPortalPos[3], StartPortalPos[4], 0, 0, StartTXT))
		{
			Sleep 1000
			ToolTip, Starting Portal, winW * 0.01, winH + 25,2
			FindText().Click(SPX + 20, SPY, MouseMovementSpeed,"L", 10)
			global ItemPortal:=1
			global Retry:=1
			global InLobby:=0
			global AllDone:=0
			Sleep 200
			MouseMove, BasicMousePos[1], BasicMousePos[2], 10
			Sleep 3000
		}
	}

	else
	{
		global ItemPortal:=0
		ToolTip, No Portals Found, winW * 0.01, winH + 25,2	
	}
	return
}

;======================================================================================

;======================================================================================
; Farm Mode

FarmMode()
{
	if (APlayOnImg:=FindText(ALX, ALY, ALobbyMenuPos[1], ALobbyMenuPos[2], ALobbyMenuPos[3], ALobbyMenuPos[4], 0, 0, APlayOnTXT))
	{
		global CheckChapter:=1
		ToolTip, Farming!, winW * 0.01, winH + 25,2
		ToolTip, In Game, winW * 0.01, winH + 50,3

		if (ModeSelected = "Story")
			ToolTip, Story | %ModeDifficulty%, winW * 0.80, winH,5
		else if (ItemPortal)
		{
			global ModeUpgrade:=1
			ToolTip, Portal, winW * 0.80, winH,5
			ToolTip,,,,4
		}
		else
			ToolTip, %ModeSelected% Mode, winW * 0.80, winH,5
		
		if (CheckUnits)
			UnitSlotsCheck()
		if (ModeUpgrade && !Maxed)
			SetTimer, UpgradeMode, 10
	}

	if (APlayOffImg:=FindText(ALX, ALY, ALobbyMenuPos[1], ALobbyMenuPos[2], ALobbyMenuPos[3], ALobbyMenuPos[4], 0, 0, APlayOffTXT))
		FindText().Click(ALX + 10, ALY, MouseMovementSpeed, "L",, 1)

	else if (!ConfigImg:=FindText(CFX, CFY, ConfigPos[1], ConfigPos[2], ConfigPos[3], ConfigPos[4], 0, 0, ConfigTXT))
	{
		SetTimer, UpgradeMode, Off
		ToolTip, Waiting!, winW * 0.01, winH + 25,2
		FindText().Click(winW / 2, winH / 3, MouseMovementSpeed, "L",,1)

		if (GameEndedImg:=FindText(GEX, GEY, GameEndedPos[1], GameEndedPos[2], GameEndedPos[3], GameEndedPos[4], 0, 0, GameEndedTXT))
		{
			Sleep 500	

			global Maxed:=0
			global Upgrading:=0
			global UpgUnit:=1
			global CheckUnits:=1

			if (Retry)
			{
				if (RetryImg:=FindText(RTX:="wait", RTY:=2, FarmingPos[1], FarmingPos[2], FarmingPos[3], FarmingPos[4], 0, 0, RetryTXT))
				{
					ToolTip, Replaying!, winW * 0.01, winH + 25,2
					Sleep 200
					FindText().Click(RTX, RTY, MouseMovementSpeed, "L",, 1)
					return
				}
			}

			if (!Retry)
			{
				if (NextImg:=FindText(NTX:="wait", NTY:=2, FarmingPos[1], FarmingPos[2], FarmingPos[3], FarmingPos[4], 0, 0, NextTXT))
				{		
					ToolTip, Continuing!, winW * 0.01, winH + 25,2
					Sleep 200
					FindText().Click(NTX, NTY, MouseMovementSpeed, "L",, 1)

					if (CheckChapter)
					{
						ModeChapter++

						if (ModeSelected = "Story")
						{
							ToolTip, %ModeStage% | Chapter %ModeChapter%, winW * 0.80, winH + 25,4
							if (ModeChapter > 10)
							{
								StageNum++
								if (StageNum >= StageCount)
								{
									global StageNum:=StageCount
								}
								ToolTip,,,,2
								ToolTip, Loading, winW * 0.01, winH + 50,3
								global Farming:=0
								global ModeChapter:=1
							}
							Gosub, StagesList
						}

						if (ModeSelected = "Ranger")
						{
							ToolTip, %ModeStage% | Act %ModeChapter%, winW * 0.80, winH + 25,4
							if (ModeChapter > ActCount)
							{
								global Farming:=0
								global ModeChapter:=1
								ToolTip,,,,4
							}		
						}
						global CheckChapter:=0
					}
					return
				}
			}

			if (LeaveGameImg:=FindText(LVGX, LVGY, FarmingPos[1], FarmingPos[2], FarmingPos[3], FarmingPos[4], 0, 0, LeaveGameTXT))
			{
				Sleep 200
				FindText().Click(LVGX, LVGY, MouseMovementSpeed, "L",, 1)
				global Farming:=0
				if (ItemPortal)
					global ModeUpgrade:=0
				global ItemPortal:=0
				ToolTip, Returning!, winW * 0.01, winH + 25,2
				ToolTip, Loading, winW * 0.01, winH + 50,3
				ToolTip,,,,4
				ToolTip,,,,5
			}			
		}
	}
	return
}

;======================================================================================

;======================================================================================
; Start Mode

StartMode()
{
	StoryMode:
	if (ModeSelected = "Story")
	{
		if (PlayImg:=FindText(LMX:="wait", LMY:=3, LobbyMenuPos[1], LobbyMenuPos[2], LobbyMenuPos[3], LobbyMenuPos[4], 0, 0, PlayTXT))
		{
			ToolTip, Play Found, winW * 0.01, winH + 25,2
			FindText().Click(LMX, LMY, MouseMovementSpeed, "L",,1)
			Sleep 1000
		}

		if (CreateRoomImg:=FindText(RMX:="wait", RMY:=3, RoomPos[1], RoomPos[2], RoomPos[3], RoomPos[4], 0, 0, CreateTXT))
		{
			FindText().Click(RMX, RMY, MouseMovementSpeed, "L",,1)
			Sleep 1000
		}

		if (CreateImg:=FindText(CX:="wait", CY:=3, CreatePos[1], CreatePos[2], CreatePos[3], CreatePos[4], 0, 0, CreateTXT))
		{
			FindText().Click(winX + 335, winY + 500, MouseMovementSpeed,"L",,1)
			ToolTip, Story Mode, winW * 0.80, winH,5
			MouseMove, winX + 167, winY + 300, 10

			StageSelect()

			ChapterSelect()

			if (DifficultyImg:=FindText(MX:="wait", MY:=3, ModePos[1], ModePos[2], ModePos[3], ModePos[4], 0, 0, DifficultyTXT))
				FindText().Click(MX, MY, MouseMovementSpeed, "L",,1)

			FindText().Click(CX, CY, MouseMovementSpeed, "L",,1)

			Sleep 1500

			if (StartRoomImg:=FindText(SX:="wait", SY:=3, StartRoomPos[1], StartRoomPos[2], StartRoomPos[3], StartRoomPos[4], 0, 0, StartTXT))
			{
				Sleep 500
				ToolTip, %ModeStage% | Chapter %ModeChapter%, winW * 0.80, winH + 25,4
				ToolTip, Story | %ModeDifficulty%, winW * 0.80, winH,5
				FindText().Click(SX + 10, SY + 5, MouseMovementSpeed, "L",,1)
				ToolTip, Starting Game, winW * 0.01, winH + 25,2
				ToolTip, Loading!, winW * 0.01, winH + 50,3
			}
			global InLobby:=0
			MouseMove, BasicMousePos[1], BasicMousePos[2], 10
		}
	}

	RangerMode:
	if (ModeSelected = "Ranger")
	{
		ToolTip,,,,4

		global StageNum:=1
		Gosub, StagesList

		if (PlayImg:=FindText(LMX:="wait", LMY:=3, LobbyMenuPos[1], LobbyMenuPos[2], LobbyMenuPos[3], LobbyMenuPos[4], 0, 0, PlayTXT))
		{
			ToolTip, Play Found, winW * 0.01, winH + 25,2
			FindText().Click(LMX, LMY, MouseMovementSpeed, "L",,1)
			Sleep 1000
		}

		if (CreateRoomImg:=FindText(RMX:="wait", RMY:=3, RoomPos[1], RoomPos[2], RoomPos[3], RoomPos[4], 0, 0, CreateTXT))
		{
			FindText().Click(RMX, RMY, MouseMovementSpeed, "L",,1)
			Sleep 1000
		}

		if (CreateImg:=FindText(CX:="wait", CY:=3, CreatePos[1], CreatePos[2], CreatePos[3], CreatePos[4], 0, 0, CreateTXT))
		{
			ToolTip, Create Room Found, winW * 0.01, winH + 25,2
			FindText().Click(winX + 480, winY + 500, MouseMovementSpeed,"L")
			ToolTip, Ranger Mode, winW * 0.80, winH,5

			StageSelect()

			if (ModePortal && AllDone)
			{
				PortalFarm()				
				return
			}

			FindText().Click(CX, CY, MouseMovementSpeed, "L",,1)

			Sleep 1500

			if (StartRoomImg:=FindText(SX:="wait", SY:=3, StartRoomPos[1], StartRoomPos[2], StartRoomPos[3], StartRoomPos[4], 0, 0, StartTXT))
			{
				Sleep 500
				ToolTip, %ModeStage% | Act %ModeChapter%, winW * 0.80, winH + 25,4
				ToolTip, Ranger Mode, winW * 0.80, winH,5
				FindText().Click(SX + 10, SY + 5, MouseMovementSpeed, "L",,1)
				ToolTip, Starting Game, winW * 0.01, winH + 25,2
				ToolTip, Loading!, winW * 0.01, winH + 50,3
				if (!ItemPortal && !ModeUpgrade)
					global ModeUpgrade:=0
			}
			else
				Goto, RangerMode

			global InLobby:=0
			MouseMove, BasicMousePos[1], BasicMousePos[2], 10
		}
	}

	ChallengeMode:
	if (ModeSelected = "Challenge")
	{
		CameraFix()

		if (AreasImg:=FindText(LMX:="wait", LMY:=10, LobbyMenuPos[1], LobbyMenuPos[2], LobbyMenuPos[3], LobbyMenuPos[4], 0, 0, AreasTXT))
		{
			ToolTip, Teleporting to Challenge Area, winW * 0.01, winH + 25,2
			FindText().Click(LMX, LMY, MouseMovementSpeed, "L",,1)
			Sleep 1000
		}

		FindText().Click(winX + 365, winY + 320, MouseMovementSpeed, "L",,1)

		Send {d down}
		Sleep 1000
		Send {d up}

		if (BackImg:=FindText(BX:="wait", BY:=3, BackPos[1], BackPos[2], BackPos[3], BackPos[4], 0, 0, BackTXT))
		{
			FindText().Click(winX + 285, winY + 340, MouseMovementSpeed, "L",,1)
			ToolTip, Creating Room, winW * 0.01, winH + 25,2
			ToolTip, Challenge Mode, winW * 0.80, winH,4
		}

		Sleep 1500

		if (StartImg:=FindText(SX:="wait", SY:=3, StartRoomPos[1], StartRoomPos[2], StartRoomPos[3], StartRoomPos[4], 0, 0, StartTXT))
		{
			Sleep 500
			FindText().Click(SX + 10, SY + 5, MouseMovementSpeed, "L",,1)
			ToolTip, Starting Game, winW * 0.01, winH + 25,2
			ToolTip, Loading!, winW * 0.01, winH + 50,3
		}

		global InLobby:=0
		MouseMove, BasicMousePos[1], BasicMousePos[2], 10
	}

	EventMode:
	if (ModeSelected = "Event")
	{
		MsgBox No Event active right now...
		Reload
	}


	return
}

;======================================================================================

;=======================================================================================================================================

;=======================================================================================================================================
; AutoFarm Macro

UpgradeMode:
if (!Upgrading)
{
	if (!UnitStatsImg:=FindText(UX1, UY1, Unit1Pos[1], Unit1Pos[2], Unit1Pos[3], Unit1Pos[4], 0, 0, UnitStatsTXT))
	{
		FindText().Click(winX + 260, winY + 230, MouseMovementSpeed,"L",,1)
		Send {t}
		Sleep 1000
	}

	if (UpgUnit = 1 && UnitSlot1)
	{
		if (UnitStatsImg:=FindText(UX1:="wait", UY1:=1, Unit1Pos[1], Unit1Pos[2], Unit1Pos[3], Unit1Pos[4], 0, 0, UnitStatsTXT))
		{
			FindText().Click(UX1 - 100, UY1 - 10, MouseMovementSpeed,"L",,1)
			Send {t}
			Sleep 1000
		}
	}

	if (UpgUnit = 2 && UnitSlot2)
	{
		if (UnitStatsImg:=FindText(UX2:="wait", UY2:=1, Unit2Pos[1], Unit2Pos[2], Unit2Pos[3], Unit2Pos[4], 0, 0, UnitStatsTXT))
		{
			FindText().Click(UX2 - 100, UY2 - 10, MouseMovementSpeed,"L",,1)
			Send {t}
			Sleep 1000
		}
	}

	if (UpgUnit = 3 && UnitSlot3)
	{
		if (UnitStatsImg:=FindText(UX3:="wait", UY3:=1, Unit3Pos[1], Unit3Pos[2], Unit3Pos[3], Unit3Pos[4], 0, 0, UnitStatsTXT))
		{
			FindText().Click(UX3 - 100, UY3 - 10, MouseMovementSpeed,"L",,1)
			Send {t}
			Sleep 1000
		}
	}
}

if (Upgrade1Img:=FindText(UX, UY, UpgradePos[1], UpgradePos[2], UpgradePos[3], UpgradePos[4], 0, 0, Upgrade1TXT))
{
	global Upgrading:=1
	FindText().Click(UX, UY + 10, MouseMovementSpeed, "L",,1)
	Sleep 200
}

else if (Upgrade2Img:=FindText(UX, UY, UpgradePos[1], UpgradePos[2], UpgradePos[3], UpgradePos[4], 0, 0, Upgrade2TXT))
{
	global Upgrading:=1
	FindText().Click(UX, UY + 10, MouseMovementSpeed, "L",,1)
	Sleep 200
}

else if (Upgrade3Img:=FindText(UX, UY, UpgradePos[1], UpgradePos[2], UpgradePos[3], UpgradePos[4], 0, 0, Upgrade3TXT))
	global Upgrading:=1

else if (UpgradeMaxImg:=FindText(UX, UY, UpgradePos[1], UpgradePos[2], UpgradePos[3], UpgradePos[4], 0, 0, UpgradeMaxTXT))
{
	if (UpgUnit = 1)
		Unit1:="Unit 1: Maxed"
	if (UpgUnit = 2)
		Unit2:="Unit 2: Maxed"
	if (UpgUnit = 3)
	{
		global Maxed:=1
		Unit3:="Unit 3: Maxed"
	}
	UpgUnit++
	FindText().Click(winX + 260, winY + 230, MouseMovementSpeed,"L",,1)
	global Upgrading:=0
	SetTimer, UpgradeMode, Off
}

if (Upgrading)
{
	if (UpgUnit = 1)
		Unit1:="Unit 1: Upgrading"
	if (UpgUnit = 2)
		Unit2:="Unit 2: Upgrading"
	if (UpgUnit = 3)
		Unit3:="Unit 3: Upgrading"
}

ToolTip, %Unit1%`t%Unit4%`t`n%Unit2%`t%Unit5%`t`n%Unit3%`t%Unit6%`t, winW * 0.37, winH + 25,12

return

Timer:
    TimerS++
    if (TimerS >= 60)
    {
        TimerS := 0
        TimerM++
    }
    if (TimerM >= 60)
    {
        TimerM := 0
        TimerH++
    }

    tooltip, Runtime: %TimerH%h %TimerM%m %TimerS%s, winX + 105, winH, 16

    if (WinExist("ahk_exe RobloxPlayerBeta.exe")) {
        if (!WinActive("ahk_exe RobloxPlayerBeta.exe")) {
            WinActivate
        }
    }
    else {
		MsgBox, 0x40030, Error, Make sure you are using the Roblox Player (not from Microsoft)
        exitapp
    }
return

Checker:
	ErrorCheck()
return

Farm:
if WinExist(Title)
{
	; Windown setup
	WinRestore
	WinMove, %Title%, , 0, 0, 500, 500
	WinActivate

	if WinActive(Title)
	{
		Essentials()
		InstanceCheck()	
		
		if (!InLobby)
		{			
			if (Farming)
				FarmMode()
		}

		if (InLobby)
		{
			if (CheckUnits)
				UnitSlotsCheck()	

			StartMode()
		}
	}
}
return

;=======================================================================================================================================


;============================================================================================================================================

; Closes the script by closing the GUI
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