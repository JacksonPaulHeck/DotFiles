import XMonad
import XMonad.Util.EZConfig

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import System.Exit

userMod 	= mod4Mask
userTerminal 	= "alacritty"
userBrowser 	= "firefox"
userPrompt 	= "dmenu_run"

userKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [
        ((modm, 		xK_b 	 ), spawn userBrowser 	     			)
      , ((modm, 		xK_c	 ), kill 		     			)
      , ((modm, 	 	xK_q     ), spawn "xmonad --recompile; xmonad --restart")
      , ((modm .|. shiftMask, 	xK_q     ), io (exitWith ExitSuccess) 			)
      , ((modm, 		xK_Return), spawn $ XMonad.terminal conf       		)
      , ((modm .|. shiftMask,  	xK_Return), windows W.swapMaster 			)
      , ((modm, 		xK_space ), spawn userPrompt 	       			)
      , ((modm, 		xK_Tab	 ), sendMessage NextLayout     			)
    ]
    ++
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

userLayout = tiled ||| Mirror tiled ||| Full
    where
	tiled 	 = Tall nmaster delta ratio
	nmaster  = 1
	ratio 	 = 1/2
	delta 	 = 3/100

main::IO ()
main = xmonad $ def {
	  modMask 	= userMod
	, terminal 	= userTerminal
	, keys 		= userKeys
	, layoutHook 	= userLayout
    }
