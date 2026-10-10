; ======================================================
; Partnered with ChatGPT - 2026-01-20
; Purpose: Automatically remember last active Explorer folder
;          and paste it via a hotkey without using clipboard
; ======================================================
;#Requires AutoHotkey v2 (Removed - had to use sendraw as sendkeys was buggy)

#Persistent
SetTimer, WatchExplorer, 500
global LastFolder := ""

WatchExplorer:
    try {
        WinGetClass, class, A
        if (class = "CabinetWClass" || class = "ExploreWClass") {
            for window in ComObjCreate("Shell.Application").Windows {
                if (window.hwnd = WinExist("A")) {
                    path := window.Document.Folder.Self.Path
                    if (path != LastFolder) {
                        LastFolder := path
                        ; Optional visual feedback:
                        ToolTip, HotFolder:`n%LastFolder%
                        SetTimer, RemoveToolTip, -2000
                    }
                }
            }
        }
    }
return

^j::   ; Ctrl + J  → "Hot Folder Reminder"
    if (LastFolder != "") {
        ToolTip, HotFolder:`n%LastFolder%
        SetTimer, RemoveToolTip, -2000
    } else {
        ToolTip, No folder captured yet.
        SetTimer, RemoveToolTip, -2000
    }
return

^m::   ; Ctrl + M  → "Hot Folder Paste"

    if (LastFolder != "") {
        SendRaw %LastFolder%
    ; Optional audible feedback:
		;SoundPlay, C:\Sys_HeartMax_Up.wav
    } else {
        ToolTip, No folder captured yet.
        SetTimer, RemoveToolTip, -1000
    }
return

RemoveToolTip:
    ToolTip
return
