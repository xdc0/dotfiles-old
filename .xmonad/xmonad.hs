import XMonad
import System.IO

import XMonad.Actions.TopicSpace

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

import XMonad.Layout.NoBorders

import XMonad.Prompt
import XMonad.Prompt.Shell

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig

main = do
    dzenWS <- spawnPipe mydzenWSbar
    dzenMIN <- spawnPipe myMonitor
    dzenBRight <- spawnPipe myBRight

    xmonad $ defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        , workspaces = myTopics
        , layoutHook = mylayoutHook
        , borderWidth = 1
        , normalBorderColor = "#4c5e52"
        , focusedBorderColor = "#4c5e52"
        , modMask = mod4Mask
        , logHook = dynamicLogWithPP $ mydzenPP dzenWS
        } `additionalKeys`

        [ ((mod4Mask, xK_w), spawn "urxvt")
        , ((mod4Mask, xK_e), spawn "firefox")
        , ((mod4Mask, xK_F2),	shellPrompt defaultXPConfig)
        ]

-- Configuration Variables

mydzenWSbar = "dzen2 -x '0' -y '0' -w '540' -ta 'l' -bg '" ++ myDBGColor ++ "' -fn '" ++ myFont ++ "'"
myMonitor = "conky | dzen2 -x '520' -y '0' -w '846' -ta 'r' -bg 'black' -fn '" ++ myFont ++ "'"
myBRight = "~/.dzen/scripts/bottomRight.zsh | dzen2 -x 0 -y 750 -ta 'r' -h 18 -bg 'black' -fn '" ++ myFont ++ "'"
myFont = "-*-terminus-medium-*-*-*-12-120-75-75-*-*-iso8859-*"
myDFGColor = "#ffffff" -- Dzen
myDBGColor = "#000000"
myFFGColor = "#3399ff" -- Focused
myFBGColor = "#000000"
myVFGColor = "#4c5e52" -- Visible
myVBGColor = "#2f3436"
myUFGColor = "#4c5e52" -- Urgent
myUBGColor = "#ffeca1"
myTFGColor = "#00ff00" -- Title
myIBGColor = myDBGColor
mySColor   = myDFGColor -- Seperator
myBorder   = "#4c5e52"
myFocusedBorder = "#4c5e52"

-- End Configuration Variables

-- Dzen Workspaces PP
--
mydzenPP h = defaultPP
     {  ppCurrent         = dzenColor myFFGColor myFBGColor . wrap "[" "]" 
      , ppVisible         = dzenColor myVFGColor myVBGColor 
      , ppUrgent          = dzenColor myUFGColor myUBGColor
      , ppTitle           = dzenColor myTFGColor myDBGColor . shorten 50
      , ppLayout          = dzenColor myDFGColor myDBGColor . wrap "|| " " ||"
      , ppSep             = " "
      , ppOutput          = hPutStrLn h }
 
mylayoutHook = avoidStruts  $  layoutHook defaultConfig 

-- Workspaces names (AKA Topics)
--

myTopics :: [Topic]
myTopics = ["main","web","term","dev","irc","im","mail","misc"]
