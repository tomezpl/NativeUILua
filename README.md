> [!WARNING]
> This is a fork of [FrazzIe's NativeUILua](https://github.com/FrazzIe/NativeUILua), the original README of which can be found below. This fork merely adds very hacky exports to make this resource usable in JavaScript resources in order for me to be able to use it in [lbg-char-neo](https://github.com/tomezpl/lbg-char-neo). It is poor code and I strongly advise against using it in any production resources. Issues and PRs in this repo will be ignored.

# NativeUI in LUA for FiveM.
![NativeUILua Example](https://i.gyazo.com/dbf3d6bed1f98fb765e5c8f25b504607.png)

Original: https://github.com/Guad/NativeUI

Include `client_script '@NativeUI/NativeUI.lua'` in your `__resource.lua` to use

## Creation Functions

`NativeUI.CreatePool()` used to handle all your menus

`NativeUI.CreateMenu(Title, Subtitle, X, Y, TxtDictionary, TxtName)` create a UIMenu

`NativeUI.CreateItem(Text, Description)` create a UIMenuItem

`NativeUI.CreateColouredItem(Text, Description, MainColour, HighlightColour)` create a UIMenuColouredItem

`NativeUI.CreateCheckboxItem(Text, Check, Description)` create a UIMenuCheckboxItem

`NativeUI.CreateListItem(Text, Items, Index, Description)` create a UIMenuListItem

`NativeUI.CreateSliderItem(Text, Items, Index, Description, Divider)` create a UIMenuSliderItem

`NativeUI.CreateProgressItem(Text, Items, Index, Description, Counter)`

`NativeUI.CreateSprite(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)` create a Sprite

`NativeUI.CreateRectangle(X, Y, Width, Height, R, G, B, A)` create a Rectangle

`NativeUI.CreateText(Text, X, Y, Scale, R, G, B, A, Font, Alignment, DropShadow, Outline, WordWrap)` create Text

### Window(s)

Used with `UIMenu` with functions `:AddWindow(Window)` and `:RemoveWindowAt(Index)`

`NativeUI.CreateHeritageWindow(Mum, Dad)`

### Panel(s)

Currently only can be used with `UIMenuListItem` with functions `:AddPanel(Panel)` and `:RemovePanelAt(Index)`

`NativeUI.CreateGridPanel(TopText, LeftText, RightText, BottomText)`

`NativeUI.CreateColourPanel(Title, Colours)`

`NativeUI.CreatePercentagePanel(MinText, MaxText)`
