|[IronToolbar Home](https://thearkive.github.io/IronToolbar_AHK/)|[Documentation](site/docs.html)| [Download](https://github.com/TheArkive/IronToolbar_AHK/archive/refs/heads/master.zip) | [Source](https://github.com/TheArkive/IronToolbar_AHK) | 
|-----------------------------|-------|------|-----|

-----------------------------------------------------------------------------------------------

<div style="font-size:12px; position:fixed; right:70px; top:10px; background-color:#000C17; padding:12px; z-index:100; border:1px solid #00ACAF; ">&nbsp;&nbsp;Table of Contents&nbsp;&nbsp;</div>

## Creating the Toolbar

Create the toolbar as follows:
`tb := gui.AddToolbar(sOptions, Styles, MixedButtons:=true, EasyMode:=true)`

Creates a new toolbar.  Many styles are applied to toolbars and the buttons automatically.  See the "Easy Mode" section below for a detailed description of toolbar and button styles that are automatically applied/removed when certain actions are triggered.

* sOptions: A string of options, formatted the same as AHK GUI options.
* Styles: A string of Styles and ExStyles to apply to the toolbar.
* MixedBtns: Boolean, true by default.\
By default, toolbar style "MixedButtons" is automatically set.  This has no effect unless the user also sets the "List" style.  To use a mix of text buttons and image buttons simply pass the "List" style in the 2nd parameter.
* EasyMode: Boolean, true by default.\
Turning off Easy Mode disables all automatic toolbar and button styles.  Use with caution!  Use tb.SendMsg() to send your own messages to the toolbar.

> Toolbar Styles:
> 
> [Toolbar Styles Reference - MS.docs](https://docs.microsoft.com/en-us/windows/win32/controls/toolbar-control-and-button-styles)\
> AltDrag, CustomErase, Flat, List, RegisterDrop, ToolTips, Transparent, Wrapable
> 
> [Window Styles Reference - also affects the toolbar - MS.docs](https://docs.microsoft.com/en-us/windows/win32/winmsg/window-styles)\
> Border, TabStop, ThickFrame, Child (these styles are rarely used directly with toolbars)
> 
> [Common Control Styles Reference - MS.docs](https://docs.microsoft.com/en-us/windows/win32/controls/common-control-styles)\
> Adjustable, Bottom, Left, Right, Top, NoDivider, NoMoveX, NoMoveY, NoParentAlign, NoResize, Vert
> 
> [Toolbar ExStyles Reference - MS.docs](https://docs.microsoft.com/en-us/windows/win32/controls/toolbar-extended-styles)\
> DoubleBuffer, DrawDDArrows, HideClippedButtons, MixedButtons\
> MultiColumn, Vertical (suggested to NOT use MultiColumn and Vertical)

## Methods

### tb.Add()

Usage: `tb.Add( [ {btn_obj}, {btn_obj}, ... ] )`

Adds buttons and separators to the toolbar.  When adding a separator, you only need to specify `{label:""}`.  Other buttons can be specified with nothing more than specifying `{label:"txt", icon:#}`, unless you want to add the other types of buttons that toolbar supports (ie. DropDown button, Check button, etc).  In this case you would need to specify all necessary `styles` and `states` to get the button and behavior you want.  See the example for how to create check buttons, and DropDown buttons with a menu.

The format for the btn_array is as follows:

```
btnArray := [ { label:"str", icon:int, styles:"str", states:"str" }
            , { ... }
            , { ... } ]
```

* label: Any string for button text.
* icon: Image List index for which icon to use (not zero-based).\
Specify `icon:-1` to make a text-only button (without an icon).
* styles: A space separated list of styles and exStyles to apply.
* states: A space separated list of states to apply.

> [Toolbar Button Styles Reference](https://docs.microsoft.com/en-us/windows/win32/controls/toolbar-control-and-button-styles)\
> AutoSize, Button, Check, CheckGroup, DropDown, Group, NoPrefix, Sep, ShowText, WholeDropDown
>
> [Toolbar Button States Reference](https://docs.microsoft.com/en-us/windows/win32/controls/toolbar-button-states)\
> Checked, Ellipses, Enabled, Hidden, Marked, Pressed, Wrap, Grayed

### tb.AutoSize()
Usage: `tb.AutoSize()`

Automatically resizes the toolbar, but not usually "good enough".  This script employs a combination of tb.AutoSize() and tb.Position() to quickly and easily get ideal resized dimensions.

### tb.ChangeBitmap()
Usage: `tb.ChangeBitmap(_in, img_idx)`

* _in: The button text string, or the 1-based index number of the button.
* img_idx: The new 1-based image index to apply to the button.

Changes the picture index of the specified button.  The new index corresponds to the applied ImageList.  The index is 1-based.

### tb.ClearButtons()
Usage: `tb.ClearButtons()`

Deletes all buttons on the toolbar.

### tb.Count()
Usage: `result := tb.BtnCount()`

Returns the number of elements in the toolbar (including separators).

### tb.CmdToIndex()
Usage: `idx := tb.CmdToIndex(idCmd)`

* idCmd: The button ID specified.  Use `tb.GetButton(idx)` to find a button's idCmd.

This is useful when using `tb.SendMsg()`.  Sometimes wParam or lParam will require the idCmd of a button instead of it's index.

### tb.Check()
Usage: `tb.Check(_in,status:=false)`

* _in: The button text string, or the 1-based index number of the button.
* status: TRUE checks the button, FALSE unchecks the button.

### tb.Count()
Usage: `btn_count := tb.Count()`

Retrieves the number of elements (buttons and separators) in the toolbar, including hidden elements.

### tb.Customizer()
Usage: `tb.Customizer()`

Invokes the improved Toolbar Customizer.  This customizer does everything the `OldCustomizer()` does, except that it will only hide buttons, not delete, when "removing" them.  You can still delete buttons with `tb.Delete(_in)`.

### tb.Delete()
Usage: `tb.Delete(_in)`

* _in: The button text string, or the 1-based index number of the button.

Delete a toolbar element.  The element can be a separator, a button, hidden, or visible.

### tb.EnableButton()
Usage: `tb.EnableButton(_in, status)`

* _in: The button text string, or the 1-based index number of the button.
* status: TRUE or FALSE.  TRUE to enable the button, FALSE to disable it.

Enables or disables a button

### tb.Export()
Usage: `map := tb.Export()`

Exports the current layout of the buttons to a Map() object.  States and styles are also preserved.  The output map is meant to be used with an object serializer in order to save it to disk.

> Recommended serializer: [JSON](https://www.autohotkey.com/boards/viewtopic.php?f=83&t=74799&sid=3c11c9a47a6500664963402ec9ccb082)

### tb.GetAllButtons()
Usage: `btn_array := tb.GetAllButtons()`

The output is a button array, the same as what is used to input into `tb.Add()`.  The main difference is that the `styles` and `states` members of each button are integers, not text strings, and there are a few more properties.

With this button array you can iterate through the buttons and inspect each propery of the buttons.

Available properties: `label, icon, styles, states, index, checked, idCmd`

### tb.GetBitmap()
Usage: `index := tb.GetBitmap(_in)`

* _in: The button text string, or the 1-based index number of the button.

The returned index is the 1-based index of the corresponding image in the currently active ImageList.

### tb.GetMetrics()
Usage: `obj := tb.GetMetrics(type:="external")`

* obj: {x, y}\
The x value is the internal/external horizontal spacing.
The y value is the internal/external vertical spacing.
* Type:\
External metrics represent the spacing of buttons from each other.  Vertical spacing only applies when the toolbar is vertical.\
Internal metrics represent the spacing between the image and the edge of the button.

### tb.GetRows()
Usage: `rows.GetRows()`

Mostly used internally for resizing.  This returns the number of rows the toolbar is currently taking up.  This value is only greater than 1 when using the Wrapable style and resizing the window to a size that requires the toolbar to use more than one row.

For some reason, the function natively returns the value as `(rows*2-1)`, resulting in values of 1, 3, 5, 7, etc.  This function attempts to fix this and output the proper number of rows.

### tb.HitTest()
Usage: `btn := tb.HitTest()`

* btn: The number of the button the mouse is currently hovering over.  If the mouse is over a separator or blank toolbar space, the result is negative and representes the absolute value of the closest button control on the toolbar.

### tb.HideButton()
Usage: `tb.HideButton(_in, status)`

* _in: The button text string, or the 1-based index number of the button.
* status: TRUE or FALSE.  TRUE to hide the button, FALSE to show it.

### tb.IL_Add()
Usage: `tb.IL_Add(ILname, file_array)`

* ILname: The name of an existing ImageList created with `tb.IL_Create()`.
* file_array: `["file/icon_index", "file/icon_index", ...].`

Adds images to an existing ImageList.

### tb.IL_Create()
Usage: `tb.IL_Create("IL_name", file_array [, Large_Icons := false])`

* IL_name: Any name you want to give to the image list.
* file_array: `["file/icon_index", "file/icon_index", ...].`
* Large_Icons: false by default.

Creates an image list and populates it with specified files.

### tb.IL_Destroy()
Usage: `tb.IL_Destroy("IL_name")`

* IL_name: The string name of the specified Image List to destroy.

### tb.Import()
Usage: `tb.Import(map)`

* map: A previously exported map using `map := tb.Export()`.

Imports the specified layout of the buttons.  States and styles are also preserved.  The input map is meant to be first loaded from a text file with an object serializer.

> Recommended serializer: [JSON](https://www.autohotkey.com/boards/viewtopic.php?f=83&t=74799&sid=3c11c9a47a6500664963402ec9ccb082)

### tb.Insert()
Usage: `tb.Insert(btn_obj, index)`

* btn_obj: this is the same as [btn_array] with `tb.Add()`, but you only pass one element.  If you try to pass more than one element you will get an error.\
EX: `[ { label:"str", icon:# } ]`

Inserts the specified button at the specified index.  The button at the index, and all buttons with a higher index, will be moved to the left.

### tb.IsChecked()
Usage: `boolean := tb.IsChecked(_in)`

* _in: The button text string, or the 1-based index number of the button.

### tb.IsEnabled()
Usage: `boolean := tb.IsEnabled(_in)`

* _in: The button text string, or the 1-based index number of the button.

### tb.IsHidden()
Usage: `boolean := tb.IsHidden(_in)`

* _in: The button text string, or the 1-based index number of the button.

### IsPressed()
Usage: `boolean := tb.IsPressed(_in)`

* _in: The button text string, or the 1-based index number of the button.

### tb.MoveButton()
Usage: `tb.MoveButton(_in, pos)`

* _in: The button text string, or the 1-based index number of the button.
* pos: The 1-based index of the position to move the button to.\
Note that separators also have an index position.

### tb.Position()
Usage: `tb.Position(pos)`

* pos: One of the following strings:  top, bottom, left, right\
Default value is "top".

### tb.SendMsg()
Usage: `result := tb.SendMsg(msg, wParam, lParam)`

Intended for advanced use.  You can exercise very precise control over the toolbar and buttons by sending your own messages if desired.

### tb.SetImageList()
Usage: `tb.SetImageList(Default [, Hot := "", Pressed := "", Disabled := ""])`

Each parameter here is the string name of the ImageList specified when initially created with `tb.IL_Create()`.

* Default: The main image list for button icons.
* Hot: The image list that is used when the mouse hovers over a button. (Optional)
* Pressed: The image list used when a button is pressed. (Optional)
* Disabled: The image list used when a button is disabled. (Optional)

For most simple implementations, you only need to specify "Default".  All other parameters are optional.  Simply pass the "IL_name" used with `tb.IL_Create()` for any of the parameters you wish to use.  See `IL_Create()` above for more info.  If you want to change button icons, you can specify a different `Default` image list.  This is useful if you want to have small and large icons ready for on-the-fly switching.

### tb.SetMetrics()
Usage: `tb.SetMetrics(x, y, type:="external")`

* x, y: The x/y values to pass for the internal or external padding.
* Type:\
External metrics represent the spacing of buttons from each other.  Vertical spacing only applies when the toolbar is vertical.\
Internal metrics represent the spacing between the image and the edge of the button.

### tb.ShowText()
Usage: `tb.ShowText(status)`

* status:  TRUE or FALSE.  TRUE to show text, FALSE to hide text.

## Properties

In addition to all the usual properties of a GUI control, you also have the following properties you can access and modify:

### tb.callback

Function object.  The default callback function is `tbEvent`.  When a Toolbar is created, the creation function will attempt only once to resolve the string-name of the function to a Func object.  Any future changes to the callback should be of type Func, BoundFunc, or a Class with a Call() method.

Changing the default callback:
```
tb := gui.AddToolbar(...)       ; Create the control.
tb.callback := my_callback      ; Set the Function object used for the Toolbar callback.  Set per toolbar.
                                ; Note, the callback func name is NOT quoted.

my_callback(...) {              ; User defined function.
                                ; See AHK v2 help on Function objects for more info. 
}
```

Default callback and parameters:
```
tbEvent(tb, lParam, dataObj) {
    ...
}
```

* tb: Toolbar Gui Control object resulting from `gui.AddToolbar()`
* lParam: Only provided for advanced usage.
* dataObj: Contains lots of info regarding the specified event.

dataObj Properties:

```
dtaObj := { event:str, eventInt:int                      Event info
          , index:int, idCmd:int, label:str              Button ID info
          , dims:{x,y,h,w,b}                             X/Y are relative to the toolbar, b is the same as y+h
          , hoverFlags:str, hoverFlagsInt:int            Hover info
          , vKey:int, char:int                           Keypress info
          , oldIndex:int, oldIdCmd:int, oldLabel:str }   More hover info for button the mouse WAS hovering over.
```

> [Toolbar WM_NOTIFY Events Reference - MS.docs](https://docs.microsoft.com/en-us/windows/win32/controls/bumper-toolbar-control-reference-notifications)

dataObj Events:

```
events: LClick, LDClick, LDown, RClick, RDClick
        Char, KeyDown
        BeginDrag, DragOut, EndDrag
        DropDown
        DeletingButton
        HotItemChange
        
        - The following events fire but do not currently populate data in dataObj.
        CustomDraw, DupAccelerator, GetDispInfo, GetObject, GetTipInfo, MapAccelerator
        ReleasedCapture, ToolTipsCreated, WrapAccelerator, WrapHotItem
```

NOTE:  A few events have been renamed for consistency, ie. `LClick` was originally `NM_CLICK`, and `LDClick` was `NM_LDBLCLK`, etc.

### tb.easyMode

Boolean.  This is `true` by default.  If you set this to `false` then all the automatic handling and sizing of the toolbar is disabled.  You will mostly need to use `tb.SendMsg()` in several manual contexts in order to manage the toolbar with easyMode disabled, but all the built-in methods will still work for basic management.

Generally speaking you should disable EasyMode on toolbar creation, not on the fly.  But you can if you want to!

### tb.h / tb.w

Integer.

`tb.h` describes the height of the toolbar when set to TOP or BOTTOM orientation with `tb.Position()`.

`tb.w` describes the width of the toolbar when set to LEFT or RIGHT orientation with `tb.Position()`.

These properties are most useful in a sizing event callback function.

### tb.hotItem

Integer.  Contains the current hot-item 1-based index.

### tb.hotItemID

Integer.  Contains the current hot-item idCmd.

### tb.hwnd

Pointer.  Stores the toolbar hwnd.

### tb.name

String.  Stores the `vName` of the control if specified in options when calling `gui.AddToolbar()`.

### tb.padding

Integer.  Number of pixels/2 to add to the toolbar height.  For most consistent results, this should be 7 or 8 pixels on most systems.  This value has more effect when the Wrapping style is used.  If this setting is too small or large, then you will either see the buttons cut off on wrapping, or you will see too much extra space on the toolbar.

The default value is 7.

### tb.txtSpacing

Integer.  Stores the number of spaces to automatically add to the left of button text (label) when `easyMode` is enabled and when `icon:-1` is specified on button creation with `tb.Add()` (which creates a text-only button, without icon).  For most non-fixed width fonts, 2 spaces should suffice.  The default value is 2.  Without adding these spaces, the button text (without an icon) would not appear centered and ends up left-aligned.

Please see the example script.

### tb.type

String.  This is always "Toolbar".

## To-Do List:

* Implement `CreateWindowEx()` to be able to add non-toolbar controls.  This will likely be in a separate class extension.
* Testing for icons larger than 32 x 32.
* Attempt to support Drop targets and TBN_GETOBJECT for drag-drop onto a toolbar.

Please let me know if you have any suggestions for different ways of handling things.  Setting `easyMode := false` has not been tested, but it is squirrly.  The toolbar is a fairly complex and unforgiving control.  Disable easyMode at your own risk!

## Easy Mode
Please read the rest of the docs above and study the included script example for appropriate context, especially if you want to deviate from "easyMode".

By default, `tb.easyMode := true` and will apply the following Styles/ExStyles automatically:

### For the Toolbar
* Flat Style (TBSTYLE_FLAT)\
Makes separators appear as bars.
* List Style (TBSTYLE_LIST)\
Makes text appear to the right of the icon.
* MixedButtons (TBSTYLE_EX_MIXEDBUTTONS)\
Hides all button text, except for buttons that have the TBSTYLE_SHOWTEXT style.
* Vertical style (CSS_VERT)\
Automatically applied when setting the toolbar orientation to RIGHT or LEFT with `tb.Position()`, or when specifying LEFT or RIGHT as a style when calling `Gui.AddToolbar()`.  When toolbar orientation is changed to TOP or BOTTOM this style is automatically removed.

### For the Toolbar Buttons
* AutoSize Style (TBSTYLE_AUTOSIZE)\
Causes the buttons with this style to automatically resize according to the displayed icon, text, and whether or not button text should be displayed.
* ShowText Style (TBSTYLE_SHOWTEXT) if `icon:-1` is specified on button creation\
This is a shorthand in easy mode to create a text button with no icon.
* Enabled State (TBSTATE_ENABED)\
This is added to every button by default.  If you want to save/restore all states of toolbar buttons easily, see `tb.Import()` and `tb.Export()` above.
* Wrap State (TBSTYLE_WRAPABLE)\
This is set to all toolbar elements when the toolbar orientation is set to RIGHT or LEFT with `tb.Position()`, or when specifying LEFT or RIGHT as a style when calling `Gui.AddToolbar()`.  When toolbar orientation is changed to TOP or BOTTOM, this style is automatically removed from all toolbar elements.

## Automatic Toolbar Sizing
To ensure your toolbar(s) are automatically sized or positioned in any orientation, simply use `Gui.OnEvent()` to bind a callback function to the "size" event, and add `Toolbar.SizeToolbar(tb, w, h)` to that sizing callback function.

This is not required.  You can still control the sizing of the toolbar manually.  In this case you will want to make use of `tb.GetRows()` when you have the Wrapable style set with a horizontal toolbar.  You will also want to use `tb.h` and `tb.w` depending on the orientation of your toolbar (top, bottom, left, right).

```
GuiSize(gui, MinMax, w, h) {
    tb := gui["MyToolbar"]          ; Per toolbar, for fully docked in
    Toolbar.SizeToolbar(tb, w, h)   ; top/bottom/left/right orientation only.
}
```