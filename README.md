A quick and dirty, spaghetti modification of Lui's DKC3 Timer Hack to add feedback for Bleak Skip (JP1.1) and Boomer 2 Skip (US).
The good parts are by Lui, the bad parts are by me :)

For Bleak Skip:
When you're in the Bleak fight, a number will be printed at the top. When you press start, it will tell you how many frames you were late by or early by (when you unpause). Different colors are used for being early/late.

For Boomer 2 Skip:
When you're in Boomer's House, a number will be printed under his desk. When you press B, it will tell you how many frames you were late by or early by. The kongs will change color depending on whether you were late (purple) or early (green)


Original Readme by Lui:

features
- frame counter on the top right of the screen, in "m ss ff" (minutes, seconds, frames). ignores loading time during transitions
- pausing the game freezes the timer display
- lag frame counter on the top left of the screen
- infinite lives

you're probably gonna need a completed save file for now, sorry

to be assembled using [Asar](https://github.com/RPGHacker/asar), see the Makefile.
