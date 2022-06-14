import XMonad
import XMonad.Util.Loggers

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import System.Exit

userMod 	= mod4Mask
userTerminal 	= "alacritty"
userBrowser 	= "brave-browser-nightly"
userPrompt 	= "dmenu_run"

userKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [
        ((modm,			xK_b 	 ), spawn userBrowser 	     			)
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

userXmobarPP :: PP
userXmobarPP = def {
      ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 80

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#ebdbb2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#ebdbb2" ""

main::IO ()
main =    xmonad 
	. ewmhFullscreen 
	. ewmh 
	. withEasySB (statusBarProp "xmobar ~/.config/xmobar/xmobarrc" (pure userXmobarPP)) toggleStrutsKey 
	$ userConfig
    where
	toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
	toggleStrutsKey XConfig{ modMask = m } = (m .|. shiftMask, xK_Tab)


userConfig = def {
	  modMask 	= userMod
	, terminal 	= userTerminal
	, keys 		= userKeys
	, layoutHook 	= userLayout
    }
