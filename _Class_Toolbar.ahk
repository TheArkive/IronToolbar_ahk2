; AHK v2
;=======================================================================================
; Class Toolbar (ClassToolbarWindow32)
; based on Class Toolbar by Pulover [Rodolfo U. Batista] for AHK v1.1.23.01 (https://github.com/Pulover/Class_Toolbar)
; Microsoft Docs Reference: https://docs.microsoft.com/en-us/windows/win32/controls/bumper-toolbar-toolbar-control-reference
;=======================================================================================
; Example
;=======================================================================================
#Include "*i TheArkive_Debug.ahk"

Global g := "", tb := "", ILA_big, ILA_small

g := Gui.New("","Toolbar Test"), g.OnEvent("close","GuiClose")

; =============================================================================
; Two different ways to use easyMode.  Don't use both at the same time.
tb := Toolbar.New(g,"vMyToolbar","Tooltips DrawDDArrows") ; DrawDDArrows used with DropDown button style below for split button.
; tb := Toolbar.New(g,"vMyToolbar","Tooltips DrawDDArrows",false) ; Disable mixed buttons.
; =============================================================================
; Hard Mode
; tb := Toolbar.New(g,"vMyToolbar","List Flat MixedButtons Tooltips DrawDDArrows",,false) ; Example below is not written for hard mode.
; =============================================================================
; To use "Hard Mode", refer to the Static members at the top of the Toolbar class.  Use those property names for styles and states.
; Pass those property names as text values in a single space-delimited string into sOptions when calling tb.New()

tb.IL_Create("big",["shell32.dll/127","shell32.dll/126","shell32.dll/129","shell32.dll/130","shell32.dll/131","shell32.dll/132","shell32.dll/133"],true) ; big icons
tb.IL_Create("small",["shell32.dll/127","shell32.dll/126","shell32.dll/129","shell32.dll/130","shell32.dll/131","shell32.dll/132","shell32.dll/133"]) ; small icons
tb.SetImageList("big") ; set big icons first

g.Add("Button","x120 y70 w100 vTop","Top").OnEvent("click","guiEvents")
g.Add("Button","xp y+0 w50 vLeft","Left").OnEvent("click","guiEvents")
g.Add("Button","x+0 w50 vRight","Right").OnEvent("click","guiEvents")
g.Add("Button","xp-50 y+0 w100 vBottom","Bottom").OnEvent("click","guiEvents")
g.Add("Button","y+10 w100 vCustomize","Old Customizer").OnEvent("click","guiEvents")
g.Add("Button","y+0 w100 vCustomizer","Customizer").OnEvent("click","guiEvents")
g.Add("Button","y+10 w100 vExIm","Export / Import").OnEvent("click","guiEvents")

g.Add("Button","x+20 y70 w50 vMove Section","Move").OnEvent("click","guiEvents")
g.Add("Text","x+2 yp+4","From:")
g.Add("Edit","x+2 yp-4 w30 Center vMoveFrom","2")
g.Add("Text","x+2 yp+4","To:")
g.Add("Edit","x+2 yp-4 w30 Center vMoveTo","3")

g.Add("Button","xs y+2 w80 vShowText Section","Show Text").OnEvent("click","guiEvents")
g.Add("Button","x+0 w80 vHideText","Hide Text").OnEvent("click","guiEvents")

g.Add("Button","xs y+0 w80 vSmallIcons","Small Icons").OnEvent("click","guiEvents")
g.Add("Button","x+0 w80 vLargeIcons","Large Icons").OnEvent("click","guiEvents")

g.Add("Button","xs y+0 w65 vHide","Hide").OnEvent("click","guiEvents")
g.Add("Button","x+0 w65 vShow","Show").OnEvent("click","guiEvents")
g.Add("Edit","x+0 w30 vHideNum Center",5)

g.Add("Button","xs y+0 w65 vEnable","Enable").OnEvent("click","guiEvents")
g.Add("Button","x+0 w65 vDisable","Disable").OnEvent("click","guiEvents")
g.Add("Edit","x+0 w30 vEnableNum Center",5)

g.Add("Text","x120 y+60","Numbers indicate positions of`r`nbuttons/separators (not zero-based).")

e := g.Add("Edit","x120 y+10 h150 w280 vEdit ReadOnly")
e.SetFont("","Consolas")

g.Show("w600 h500")

tb.Add([{label:"Button 1", icon:-1} ; set icon:-1 to use a text button (automatically applies "ShowText" style)
       ,{label:""}                  ; set label:"" and no other properties to use a separator
       ,{label:"Button 2", icon:2, styles:"ShowText"} ; set icon index and "ShowText" style to have a button with icon and text
       ,{label:""}
       ,{label:"Button 3", icon:3, styles:"WholeDropDown"}  ; DropDown button with arrow NOT split from main button
       ,{label:"Button 4", icon:4, styles:"DropDown"}       ; DropDown split button, requires DrawDDArrows style above
       ,{label:""}
       ,{label:"Button 5", icon:5, styles:"Check CheckGroup"} ; index 8
       ,{label:"Button 6", icon:6, styles:"Check CheckGroup"} ; index 9
       ,{label:""}
       ,{label:"Button 7", icon:7, styles:"Check"}])


; d props: {event:str, eventInt:int                         ; event data
        ; , index:int, idCmd:int, label:str                 ; data for clicked/hovered button
        ; , dims:{x:int, y:int, b:int, w:int, h:int}        ; button x/y/w/y, b = bottom of button y value
        ; , hoverFlags:str, hoverFlagsInt:int               ; more specific hover data
        ; , vKey:int, char:int                              ; when hovering + keystroke, these are populated
        ; , oldIndex:int, oldIdCmd:int, oldLabel:str}       ; for initially dragged button, or previous hot item
           
; events: LClick, LDClick, LDown, RClick, RDClick   ; mouse click events
        ; Char, KeyDown                             ; hover + keystroke events
        ; BeginDrag, DragOut, EndDrag, DragOver     ; drag/drop events
        ; DropDown                                  ; clicking drop-down arrow (on separated drop-down button)
        ; DeletingButton                            ; delete button event
        ; HotItemChange                             ; hover events
        ;
        ; NOTE: I have yet to get the DragOver event to actually fire.
        ;
        ; - These events fire but do not currently populate data in dataObj.
        ; CustomDraw, DupAccelerator, GetDispInfo, GetObject, GetTipInfo, MapAccelerator, ReleasedCapture, ToolTipsCreated, WrapAccelerator, WrapHotItem

; See Static wm_n member for a full list of events.
tbEvent(tb, lParam, dataObj) {
    char := (dataObj.char > 0) ? Chr(dataObj.char) : ""
    
    If InStr(dataObj.event,"hot")
        g["Edit"].Value := "Hot Item:`r`n`r`n"
                         . "Event: " dataObj.event "`r`n"
                         . "index / idCmd / label / checked:`r`n    " dataObj.index " / " dataObj.idCmd " / " dataObj.label " / " dataObj.checked "`r`n`r`n"
                         . "old index / idCmd:     " dataObj.oldIndex " / " dataObj.oldIdCmd "`r`n`r`n"
                         . "flags: " dataObj.hoverFlags " / " Format("0x{:X}",dataObj.hoverFlagsInt) "`r`n"
                         . "RECT X/Y/W/H: " dataObj.dims.X " / " dataObj.dims.Y " / " dataObj.dims.W " / " dataObj.dims.H
    Else If InStr(dataObj.event,"drag")
        g["Edit"].Value := "Drag Info:`r`n`r`n"
                         . "Event: " dataObj.event "`r`n"
                         . "index / idCmd / label / checked:`r`n    " dataObj.index " / " dataObj.idCmd " / " dataObj.label " / " dataObj.checked "`r`n`r`n"
                         . "old index / idCmd:     " dataObj.oldIndex " / " dataObj.oldIdCmd "`r`n`r`n"
                         . "RECT X/Y/W/H: " dataObj.dims.X " / " dataObj.dims.Y " / " dataObj.dims.W " / " dataObj.dims.H
    Else If (dataObj.event = "char") Or (dataObj.event = "KeyDown")
        g["Edit"].Value := "Keyboard Events:`r`n`r`n"
                         . "Event: " dataObj.event "`r`n"
                         . "vKey: " dataObj.vKey "`r`n"
                         . "Char: " dataObj.char " / " char "`r`n"
                         . "index / idCmd / label / checked:`r`n    " dataObj.index " / " dataObj.idCmd " / " dataObj.label " / " dataObj.checked "`r`n`r`n"
    Else If (dataObj.event = "DropDown")
        msgbox "Drop arrow clicked on a split button, or DropDown button with WholeDropDown style clicked."
    
    ; Else If (InStr(dataObj.event,"click")) ; Choose an event to filter by, and if needed, a specific button.
        ; Msgbox dataObj.label " clicked."   ; You can identify buttons by idCmd, index, or label from dataObj.
}

guiEvents(ctl,info) {
    n := ctl.Name
    If (n="top" or n="left" or n="right" or n="bottom")
        tb.Position(n)
    Else If (n="Move")
        tb.MoveButton(ctl.gui["MoveFrom"].Value,ctl.gui["MoveTo"].Value)
    Else If (n="ShowText")
        tb.ShowText(true)
    Else If (n="HideText")
        tb.ShowText(false)
    Else If (n="SmallIcons")
        tb.SetImageList("small")
    Else If (n="LargeIcons")
        tb.SetImageList("big")
    Else If (n="Hide")
        tb.HideButton(ctl.gui["HideNum"].Value,true)
    Else If (n="Show")
        tb.HideButton(ctl.gui["HideNum"].Value,false)
    Else If (n="Enable")
        tb.EnableButton(ctl.gui["EnableNum"].Value,true)
    Else If (n="Disable")
        tb.EnableButton(ctl.gui["EnableNum"].Value,false)
    Else If (n="Customize")
        tb.OldCustomize()
    Else If (n="Customizer")
        tb.Customizer()
    Else If (n="ExIm") {
        Msgbox "Exporting/Clearing the toolbar...."
        btnLayout := tb.Export()
        tb.ClearButtons()
        MsgBox "Now importing."
        tb.Import(btnLayout)
    }
}

GuiClose(g) {
    ExitApp
}

F1::MsgBox tb.GetButtonText(5)

;=======================================================================================
; End Example
;=======================================================================================
;
; Toolbar Class
;
;=======================================================================================
;=======================================================================================

class Toolbar { ; extends Toolbar.Private {
    Static TBBUTTON_size := ((A_PtrSize = 4) ? 20 : 32), NMHDR_size := (A_PtrSize * 3)
    Static txtSpacing := 2 ; Adds spaces in front of button text.  For forcing "center" on a toolbar button text with no icon.
    
    Static styles := {AltDrag:0x400       ; Toolbar Styles https://docs.microsoft.com/en-us/windows/win32/controls/toolbar-control-and-button-styles
                    , CustomErase:0x2000, Flat:0x800, List:0x1000, RegisterDrop:0x4000, ToolTips:0x100, Transparent:0x8000, Wrapable:0x200
                    
                    , Border:0x800000, TabStop:0x10000, ThickFrame:0x40000 ; Window Styles https://docs.microsoft.com/en-us/windows/win32/winmsg/window-styles
                    , Child:0x40000000
                    
                    , Adjustable:0x20     ; Common Control Styles https://docs.microsoft.com/en-us/windows/win32/controls/common-control-styles
                    , Bottom:0x3, Left:0x81, Right:0x83, Top:0x1, NoDivider:0x40, NoMoveX:0x82, NoMoveY:0x2, NoParentAlign:0x8, NoResize:0x4, Vert:0x80}
                    
    Static bStyles := {AutoSize:0x10      ; Toolbar Button Styles https://docs.microsoft.com/en-us/windows/win32/controls/toolbar-control-and-button-styles
                    , Button:0, Check:0x2, CheckGroup:0x6, DropDown:0x8, Group:0x4, NoPrefix:0x20, Sep:0x1, ShowText:0x40, WholeDropDown:0x80}
    
    Static exStyles := {DoubleBuffer:0x80 ; Extended Toolbar Styles https://docs.microsoft.com/en-us/windows/win32/controls/toolbar-extended-styles
                      , DrawDDArrows:0x01, HideClippedButtons:0x10, MixedButtons:0x08, MultiColumn:0x02, Vertical:0x04}
    
    Static states := {Checked:0x01        ; Toolbar Button States https://docs.microsoft.com/en-us/windows/win32/controls/toolbar-button-states
                    , Ellipses:0x40, Enabled:0x04, Hidden:0x08, Marked:0x80, Pressed:0x02, Wrap:0x20, Grayed:0x10} ; TBSTATE_INDETERMINATE = Grayed = 0x10
    
    Static flags := {Large:0x1            ; TB_GETBITMAPFLAGS https://docs.microsoft.com/en-us/windows/win32/controls/tb-getbitmapflags
    
                   , ByIndex:0x80000000   ; TBBUTTONINFOA dwMask https://docs.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tbbuttoninfoa
                   , Command:0x20, Image:0x1, lParam:0x10, Size:0x40, State:0x4, Style:0x8, Text:0x2}
    
    Static wm_n := {BeginAdjust:-703      ; WM_NOTIFY Toolbar Notifications https://docs.microsoft.com/en-us/windows/win32/controls/bumper-toolbar-control-reference-notifications
                  , BeginDrag:-701, CustHelp:-709, DeletingButton:-715, DragOut:-714, DragOver:-727, DropDown:-710, DupAccelerator:-725, EndAdjust:-704
                  , EndDrag:-702, GetObject:-712, HotItemChange:-713, InitCustomize:-723, MapAccelerator:-728, QueryDelete:-707, QueryInsert:-706
                  , Reset:-705, Restore:-721, Save:-722, ToolbarChange:-708, WrapAccelerator:-726, WrapHotItem:-724, EndCustomize:2 ; TBNRF_ENDCUSTOMIZE
                  , GetButtonInfo:((A_PtrSize=8)?-720:-700), GetDispInfo:((A_PtrSize=8)?-717:-716), GetInfoTip:((StrLen(Chr(0xFFFF)))?-719:-718)
                  
                  , Char:-18 ; NM_* events https://docs.microsoft.com/en-us/windows/win32/controls/bumper-toolbar-control-reference-notifications
                  , CustomDraw:-12, KeyDown:-15, LDown:-20, ReleasedCapture:-16, ToolTipsCreated:-19, LClick:-2, LDClick:-3, RClick:-5, RDClick:-6, BN_CLICKED:2}
    
    Static messages := {_AddButtons:0x414 ; Toolbar Messages https://docs.microsoft.com/en-us/windows/win32/controls/bumper-toolbar-control-reference-messages
                      , _AddString:(StrLen(Chr(0xFFFF))?0x044D:0x041C), _AutoSize:0x421, _ButtonCount:0x418, _CheckButton:0x402, _CommandToIndex:0x419
                      , _Customize:0x41B, _DeleteButton:0x416, _EnableButton:0x401, _GetButton:0x417, _GetButtonSize:0x43A, _GetButtonInfo:(StrLen(Chr(0xFFFF))?0x43F:0x441)
                      , _GetButtonText:(StrLen(Chr(0xFFFF))?0x044B:0x042D), _GetExtendedStyle:0x455, _GetHotItem:0x447, _GetIdealSize:0x463, _GetImageList:0x431
                      , _GetImageListCount:0x462, _GetItemDropDownRect:0x467, _GetItemRect:0x41D, _GetMaxSize:0x453, _GetPadding:0x456
                      , _GetRect:0x433, _GetRows:0x428, _GetState:0x412, _GetStyle:0x439, _GetString:(StrLen(Chr(0xFFFF))?0x045B:0x045C), _GetTextRows:0x43D
                      , _HideButton:0x404, _Indeterminate:0x405, _InsertButton:(StrLen(Chr(0xFFFF))?0x0443:0x0415), _IsButtonChecked:0x40A, _IsButtonEnabled:0x40A
                      , _IsButtonHidden:0x40C, _IsButtonHighlighted:0x40E, _IsButtonIndeterminate:0x40D, _IsButtonPressed:0x40B, _MakeButton:0x406
                      , _MoveButton:0x452, _PressButton:0x403, _SetButtonInfo:(StrLen(Chr(0xFFFF))?0x0440:0x0442), _SetButtonSize:0x41F, _SetButtonWidth:0x43B
                      , _SetDisabledImageList:0x436, _SetExtendedStyle:0x454, _SetHotImageList:0x434, _SetHotItem:0x448, _SetHotItem2:0x45E
                      , _SetImageList:0x430, _SetIndent:0x42F, _SetListGap:0x460, _SetMaxTextRows:0x43C, _SetMetrics:0x466, _SetPadding:0x457, _SetPressedImageList:0x468
                      , _SetRows:0x427, _SetState:0x411, _SetStyle:0x438, _HitTest:0x445, _GetAnchorHighlight:0x44A, _SetAnchorHighlight:0x449}
    
    Static hotItemFlags := {Accelerator:0x4 ; https://docs.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-nmtbhotitem
                          , ArrowKeys:0x2, DupAccel:0x8, Entering:0x10, Leaving:0x20, LMouse:0x80, Mouse:0x1, Reselect:0x40, ToggleDropDown:0x100} ; Other:0x0
    
    Static metrics := {Pad:0x1, BarPad:0x2, ButtonSpacing:0x4}
    
    hwnd:=0, _gui:="", ctrl:="", Name:="", Type:="Toolbar"
    ShowText := true, MixedBtns := true, easyMode := true, pos:="top", exStyles := "", startStyles := "", counter := 1
    callback := "tbEvent", reAddButton := true, hotItem := 0, hotItemID := 0
    
    ImageLists := "", IL_Default := "", IL_Hot := "", IL_Pressed := "", IL_Disabled := ""
    NMHDR:={}, NMMOUSE:={}, NMKEY:={}, btns := [], btnsBackup :=[]
    
    __New(in_gui:="", sOptions:="", Styles:="", MixedBtns := true, EasyMode := true) {  ; TBSTYLE_FLAT     := 0x0800 Required to show separators as bars.
        _Styles := "", this.startStyles := Styles, this.ImageLists := Map(), this.ImageLists.CaseSense := false, this.MixedBtns := MixedBtns
        
        this.easyMode := EasyMode
        (!this.easyMode) ? this.MixedBtns := false : ""
        
        Loop Parse Trim(Styles), " "
        {
            v := A_LoopField
            If (v="DrawDDArrows" Or v="HideClippedButtons" Or v="DoubleBuffer" Or v="MixedButtons" Or v="MultiColumn" Or v="Vertical") {
                this.exStyles .= A_LoopField " "
                Continue
            }
            If this.easyMode {
                If (v="top" Or v="bottom" or v="left" Or v="right")
                    this.pos := A_LoopField
                Else
                    (v = "ShowText") ? this.%v% := true : _Styles .= this.lu(A_LoopField,true) " "
            } Else
                _Styles .= this.lu(A_LoopField,true) " "
        }
        
        If this.easyMode { ; final easy mode modifications
            (!InStr(Styles,"NoParentAlign")) ? (_Styles .= " " this.lu("NoParentAlign",true), this.startStyles .= " NoParentAlign") : ""
            (!InStr(Styles,"NoResize")) ? (_Styles .= " " this.lu("NoResize",true), this.startStyles .= " NoResize") : ""
            (!InStr(Styles,"Flat")) ? (_Styles .= " " this.lu("Flat",true), this.startStyles .= " Flat") : ""
            (MixedBtns And !InStr(Styles,"List")) ? (_Styles .= " " this.lu("List",true), this.startStyles .= " List") : ""
            (MixedBtns And !InStr(Styles,"MixedButtons")) ? this.exStyles .= "MixedButtons " : ""
            this.startStyles := RegExReplace(this.startStyles,"i)(left|right|top|bottom)","")
            this.startStyles := Trim(RegExReplace(this.startStyles,"[ ]{2,}"," "))
            
            For prop, value in Toolbar.exStyles.OwnProps() ; filter out exStyles from main startStyles
                this.startStyles := RegExReplace(StrReplace(this.startStyles,prop,""),"[ ]{2,}"," ")
        }
        
        ; wm_cmd := ObjBindMethod(this,"WM_COMMAND")
        ; OnMessage 0x111, wm_cmd
        
        this._gui := in_gui
        ctl := this._gui.Add("Custom","ClassToolbarWindow32 " sOptions " " _Styles)
        this.ctrl := ctl, this.hwnd := ctl.hwnd, this.Name := ctl.Name
        
        For prop, value in Toolbar.wm_n.OwnProps() ; register callback for several WM_NOTIFY events
            this.ctrl.OnNotify(value,ObjBindMethod(this,"__tbNotify"))
        
        this.SendMsg(this._SetExtendedStyle, 0, this.MakeFlags(this.exStyles,"exStyles"))
        
        this.NMHDR := Toolbar.NMHDR.New(), this.NMMOUSE := Toolbar.NMMOUSE.New(), this.NMKEY := Toolbar.NMKEY.New() ; initialize structures
        
        ; this.SendMsg(this._SetButtonWidth,0,this.MakeLong(16,200))
    }
    ; WM_COMMAND(wParam, lParam, msg, hwnd) {
        ; Debug.Msg(wParam " / " lParam " / " msg " / " hwnd)
    ; }
    __Get(key,p) {
        result := this.lu(key)
        If !result
            throw Exception("Invalid property specified: " key, -1)
        Else return result
    }
    lu(sInput,TextOutput := false) { ; LookUp - return integer
        If (Toolbar.styles.HasOwnProp(sInput))
            output := Toolbar.styles.%sInput%
        Else If (Toolbar.bStyles.HasOwnProp(sInput))
            output := Toolbar.bStyles.%sInput%
        Else If (Toolbar.exStyles.HasOwnProp(sInput))
            output := Toolbar.exStyles.%sInput%
        Else If (Toolbar.states.HasOwnProp(sInput))
            output := Toolbar.states.%sInput%
        Else If (Toolbar.flags.HasOwnProp(sInput))
            output := Toolbar.flags.%sInput%
        Else If (Toolbar.wm_n.HasOwnProp(sInput))
            output := Toolbar.wm_n.%sInput%
        Else If (Toolbar.messages.HasOwnProp(sInput))
            output := Toolbar.messages.%sInput%
        Else If (sInput = "hide")
            return Toolbar.states.Hidden
        Else
            return ; throw Exception("Unknown property: " sInput)
        
        output := TextOutput ? Format("0x{:X}",output) : output
        return output
    }
    rlu(iInput, member) { ; reverse lookup constant by value (usually only for events)
        If (iInput = "")
            return ""
        output := ""
        For prop, value in Toolbar.%member%.OwnProps() {
            If (value = iInput) {
                output := prop
                Break
            }
        }
        If !output
            Msgbox "Unknown value: " iInput " / " Format("0x{:X}",iInput) " / Type: " Type(iInput) " / Len: " StrLen(iInput)
        Else return output
    }
    AutoSize() {
        PostMessage this._AutoSize, 0, 0,this.hwnd ; no return value, and no more ErrorLevel... hm...
    }
    AddConvert(btnArray,initial) { ; for internal use only
        For i, b in btnArray {
            If !b.HasProp("label")
                throw Exception("Button data must contain a label property.")
            
            (b.label="") ? sep := true : sep := false
            (!b.HasProp("icon")) ? b.icon := 0 : (initial) ? b.icon -= 1 : ""   ; initial only
            (!b.HasProp("idCmd")) ? b.idCmd := 1000+(this.counter++) : ""       ; initial only
            
            If (initial And !sep) {
                (initial And !b.HasProp("states")) ? b.states := "Enabled" : ""
                (initial And this.easyMode And !InStr(b.states,"Enabled")) ? b.states .= " Enabled" : ""
                
                (initial And Type(b.states)="String") ? b.states := this.MakeFlags(b.states,"states") : ""  ; initial only
                
                (initial And !b.HasProp("styles")) ? b.styles := "AutoSize" : ""
                (initial And this.easyMode And !InStr(b.styles,"AutoSize")) ? b.styles .= " AutoSize" : ""
                (initial And this.easyMode And this.MixedBtns And b.icon = -2 And !InStr(b.styles,"ShowText")) ? b.styles .= " ShowText" : ""
                
                (initial And Type(b.styles)="String") ? b.styles := this.MakeFlags(b.styles,"bStyles") : "" ; initial only
            } Else If (initial and sep)
                b.styles := 1, b.states := 0
            
            (initial And !b.HasProp("iString")) ? b.iString := -1 : ""
            (b.icon < 0) ? b.label := this.StrRpt(" ",Toolbar.txtSpacing) b.label : ""
            btnArray[i] := b
        }
        
        return btnArray
    }
    StrRpt(str,count) {
        result := ""
        Loop count
            result .= str
        return result
    }
    Add(btnArray, initial:=true) {
        If initial
            btnArray := this.AddConvert(btnArray,initial)
        TBBUTTON := BufferAlloc(Toolbar.TBBUTTON_size * btnArray.Length, 0)
        offset := 0
        
        For i, b in btnArray ; add buttons
            this.Fill_TBBUTTON(TBBUTTON, offset, b.label, b.icon, b.idCmd, b.states, b.styles, b.iString), offset += Toolbar.TBBUTTON_size
        
        result := this.SendMsg(this._AddButtons, btnArray.Length, TBBUTTON.ptr)
        this.SendMsg(this._SetMaxTextRows,this.ShowText ? 1 : 0) ; set text display mode
        
        If (this.easyMode And initial) {
            this.Position(this.pos) ; position toolbar after button add?
            this.Position(this.pos)
        }
         
        this.AutoSize(), this.reAddButton := true
    }
    IsChecked(idx,int := false) {
        TBBUTTON := BufferAlloc(Toolbar.TBBUTTON_size,0)
        r := this.SendMsg(this._GetButton,idx-1,TBBUTTON.ptr)
        states := NumGet(TBBUTTON,8,"Char"), TBBUTTON := ""
        return !!(states & Toolbar.states.Checked) ; only return 1 or 0
    }
    Insert(b,idx) {
        a := this.AddConvert(b,true), b := a[1]
        TBBUTTON := BufferAlloc(Toolbar.TBBUTTON_size, 0)
        this.Fill_TBBUTTON(TBBUTTON, offset:=0, b.label, b.icon, b.idCmd, b.states, b.styles, b.iString)
        this.SendMsg(this._InsertButton,idx-1,TBBUTTON.ptr)
    }
    MakeFlags(sInput,member) { ; return toolbar styles integer from space delimited text input
        output := 0
        Loop Parse Trim(sInput), " "
        {
            If IsInteger(A_LoopField)
                throw Exception("No numeric property: " member " / Value: " A_LoopField)
            output := output | Toolbar.%member%.%A_LoopField%
        }
        return output
    }
    GetFlags(iInput,member) { ; return text names of properties from given input integer, must specify static member above to search
        output := ""
        For prop, value in Toolbar.%member%.OwnProps()
            (iInput & value) ? output .= prop " " : ""
        return Trim(output)
    }
    EnableButton(idx, status) {
        btns := this.SaveNewLayout()
        result := this.SendMsg(this._EnableButton,btns[idx].idCmd,this.MakeLong(status,0))
        return result
    }
    HideButton(idx, status) {
        btns := this.SaveNewLayout()
        result := this.SendMsg(this._HideButton,btns[idx].idCmd,this.MakeLong(status,0))
        return result
    }
    MoveButton(idx,pos) {
        result := this.SendMsg(this._MoveButton,idx-1,pos-1)
        return result
    }
    ClearButtons() {
        While this.SendMsg(this._DeleteButton, 0,0)
            i := 1
    }
    Position(p:="", repeat:=false) {
        this.pos := p
        dims := this.GetButtonDims() ; bWidth, bHeight, hPad, vPad
        this._gui.GetClientPos(,,w,h)
        height := dims.h+2, width := dims.w+2
        
        If (p="right") {
            this.ctrl.Move(w-width,0,width,h)
            this.SendMsg(this._SetStyle, 0, this.MakeFlags(this.startStyles " Vert","styles"))
        } Else If (p="bottom") {
            this.ctrl.Move(0,h-height,w,height)
            this.SendMsg(this._SetStyle, 0, this.MakeFlags(this.startStyles,"styles"))
        } Else If (p="left") {
            this.ctrl.Move(0,0,width,h)
            this.SendMsg(this._SetStyle, 0, this.MakeFlags(this.startStyles " Vert","styles"))
        } Else { ; top
            this.ctrl.Move(0,0,w,height)
            this.SendMsg(this._SetStyle, 0, this.MakeFlags(this.startStyles,"styles"))
        }
        
        btns := this.SaveNewLayout()
        For i, b in btns { ; modify button state / add or remove "Wrap" state for orientation
            statesTxt := this.GetFlags(b.states,"states")
            
            If (p="left" Or p="right") And !InStr(statesTxt,"Wrap")
                statesTxt .= " Wrap"
            Else If (p="top" Or p="bottom") And InStr(statesTxt,"Wrap")
                statesTxt := RegExReplace(StrReplace(statesTxt,"Wrap"),"[ ]{2,}"," ")
            
            b.states := this.MakeFlags(statesTxt,"states")
            b.icon -= 1
        }
        
        this.ClearButtons()
        this.Add(btns,false)
    }
    ShowText(status) {
        this.ShowText := status
        this.SendMsg(this._SetMaxTextRows,status)
        this.Position(this.pos) ; 2x redraws required for proper dimensions
        this.Position(this.pos)
    }
    OldCustomize() {
        this.SendMsg(this._Customize, 0, 0)
    }
    Delete(idx) {
        return this.SendMsg(this._DeleteButton, idx-1,0)
    }
    Fill_TBBUTTON(TBBUTTON, offset, label, iBitmap, idCommand, fsState, fsStyle, iString:=-1) {
        encoding := !StrLen(Chr(0xFFFF)) ? "UTF-8" : "UTF-16"
        
        If (iString = -1) { ; create string and add to pool
            BTNSTR := BufferAlloc(StrPut(label,encoding), 0)
            StrPut(label, BTNSTR.ptr, encoding)
            iString := SendMessage(this._AddString, 0, BTNSTR.ptr, this.hwnd)
        }
        
        NumPut "Int", iBitmap, "Int", idCommand, "Char", fsState, "Char", fsStyle, TBBUTTON, offset
        If iString >= 0
            NumPut "Ptr", iString, TBBUTTON, ((A_PtrSize = 4) ? 16+offset : 24+offset)
        
        return iString
    }
    GetButton(idx) {
        TBBUTTON := BufferAlloc(Toolbar.TBBUTTON_size,0), r := this.SendMsg(this._GetButton,idx-1,TBBUTTON.ptr)
        iImg := NumGet(TBBUTTON,"Int"), idCmd := NumGet(TBBUTTON,4,"UInt"), states := NumGet(TBBUTTON,8,"Char"), styles := NumGet(TBBUTTON,9,"Char")
        iString := NumGet(TBBUTTON,((A_PtrSize=4)?16:24),"Ptr"), txt := this.GetButtonText(idx)
        return {index:idx, label:txt, icon:iImg+1, states:states, styles:styles, checked:!!(states & Toolbar.states.Checked), idCmd:idCmd, iString:iString}
    }
    ; GetButtonInfo(idx, byIndex:=false) { ; need to turn this into SetButtonText()
        ; TBI := BufferAlloc(bSize:=(A_PtrSize=4)?32:48,0)
        ; dwMask := this.Command|this.Image|this.Size|this.State|this.Style
        ; (byIndex) ? (dwMask := dwMask | this.ByIndex) : ""
        
        ; NumPut "UInt", bSize, "Int", dwMask, TBI
        ; r := this.SendMsg(this._GetButtonInfo, idx, TBI.Ptr)
        ; idCmd := NumGet(TBI, 8, "Int"), iImg  := NumGet(TBI, 12, "Int")
        ; states := NumGet(TBI, 16, "UChar"), styles := NumGet(TBI, 17, "UChar"), width  := NumGet(TBI, 18, "UShort")
        
        ; tSize := this.SendMsg(this._GetButtonText, idCmd, 0)
        ; tBuf := BufferAlloc((tSize+1) * (StrLen(Chr(0xFFFF))?2:1),0)
        ; this.SendMsg(this._GetButtonText, idCmd, tBuf.Ptr), txt := StrGet(tBuf)
        
        ; TBBUTTON := BufferAlloc(Toolbar.TBBUTTON_size,0)
        ; r := this.SendMsg(this._GetButton,idx,TBBUTTON.ptr)
        ; iString := NumGet(TBBUTTON,((A_PtrSize=4)?16:24),"Ptr")
        
        ; return {label:txt, icon:iImg, states:states, styles:styles, idCmd:idCmd, iString:iString} ; iString (str idx)
    ; }
    GetButtonText(idx) {
        TBBUTTON := BufferAlloc(Toolbar.TBBUTTON_size,0)
        r := this.SendMsg(this._GetButton,idx-1,TBBUTTON.ptr)
        idCmd := NumGet(TBBUTTON,4,"UInt")
        
        tSize := this.SendMsg(this._GetButtonText, idCmd, 0) << 32 >> 32 ; needed for 32-bit compatibility
        
        If (tSize = -1)
            return ""
        
        TBBUTTON := "", tBuf := BufferAlloc((tSize+1) * (StrLen(Chr(0xFFFF)) ? 2 : 1),0)
        this.SendMsg(this._GetButtonText, idCmd, tBuf.Ptr), txt := StrGet(tBuf)
        return txt
    }
    GetButtonDims() {
        btns := this.SaveNewLayout()
        
        _RECT := BufferAlloc(16,0), bWidth := 0, bHeight := 0
        For i, b in btns {
            TBI := BufferAlloc(bSize:=(A_PtrSize=4)?32:48,0)
            dwMask := this.Style
            NumPut "UInt", bSize, "Int", dwMask, TBI
            this.SendMsg(this._GetButtonInfo,b.idCmd,TBI.ptr)
            styles := NumGet(TBI,17,"Char")
            If (styles & Toolbar.bStyles.Sep) ; check and skip if separator
                continue
            
            r := this.SendMsg(this._GetRect, b.idCmd, _RECT.ptr)
            l := NumGet(_RECT,0,"UInt"), t := NumGet(_RECT,4,"UInt"), r := NumGet(_RECT,8,"UInt"), b := NumGet(_RECT,12,"UInt")
            w := r-l, h := b-t
            bWidth := (bWidth < w) ? w : bWidth
            bHeight := (bHeight < h) ? h : bHeight
        }
        padding := this.SendMsg(this._GetPadding, 0, 0), this.MakeShort(padding, hPad, vPad)
        dims := {w:bWidth, h:bHeight, hPad:hPad, vPad:vPad}, TBI := "", _RECT := ""
        return dims
    }
    CmdToIdx(idCmd) {
        return (this.SendMsg(this._CommandToIndex,idCmd)+1) << 32 >> 32
    }
    BtnCount() {
        return this.SendMsg(this._ButtonCount)
    }
    __tbNotify(ctl, lParam) { ; TB_HITTEST / TB_GETRECT/TB_GETITEMRECT ; https://docs.microsoft.com/en-us/windows/win32/controls/bumper-toolbar-control-reference-notifications
        this.ResetStructs(), p := A_PtrSize, encoding := !StrLen(Chr(0xFFFF)) ? "UTF-8" : "UTF-16"
        
        this.NMHDR.hwnd   := NumGet(lParam,"Ptr")
        this.NMHDR.idFrom := NumGet(lParam+A_PtrSize,"UInt")
        this.NMHDR.code   := NumGet(lParam+(A_PtrSize * 2),"Int") ; Technically a UINT / WM_NOTIFY msg code
        
        ; If this.NMHDR.code = 0
            ; msgbox "btn click"
        
        event := this.rlu(this.NMHDR.code,"wm_n") ; lookup event name
        ; Debug.Msg(event)
        
        If (this.NMHDR.code = 0 or this.NMHDR.code = "" Or event = "")
            return
        
        o := {event:event, eventInt:this.NMHDR.code
            , index:0, idCmd:0, label:"", checked:0, dims:{x:0, y:0, w:0, h:0} ; data for clicked/hovered button | old: rect:{t:"", b:"", r:"", l:""}
            , hoverFlags:"", hoverFlagsInt:0                        ; more specific hover data
            , vKey:-1, char:-1                                      ; when hovering + keystroke, these are populated
            , oldIndex:0, oldIdCmd:0, oldLabel:""}                  ; for initially dragged button, or previous hot item
        
        Switch this.NMHDR.code { ; WM_NOTIFY msgs ; https://docs.microsoft.com/en-us/windows/win32/controls/bumper-toolbar-control-reference-notifications
            Case this.LClick, this.LDClick, this.LDown, this.RClick, this.RDClick:
                this.NMMOUSE.dwItemSpec := NumGet(lParam+Toolbar.NMHDR_size,"Ptr")
                this.NMMOUSE.dwItemData := NumGet(lParam+Toolbar.NMHDR_size+A_PtrSize,"UPtr")
                this.NMMOUSE.pointX := NumGet(lParam+Toolbar.NMHDR_size+(A_PtrSize * 2),"UInt")
                this.NMMOUSE.pointY := NumGet(lParam+Toolbar.NMHDR_size+(A_PtrSize * 2)+4,"UInt")
                this.NMMOUSE.dwHitInfo := NumGet(lParam+Toolbar.NMHDR_size+(A_PtrSize * 2)+8,"UInt")
                
                b := this.GetButton(this.CmdToIdx(this.NMMOUSE.dwItemSpec))
                
                o.idCmd := b.idCmd, o.index := b.index, o.label := b.label
                
            Case this.Char: ; https://docs.microsoft.com/en-us/windows/win32/controls/nm-char-toolbar
                char := NumGet(lParam+Toolbar.NMHDR_size,"UInt")
                dwItemPrev := NumGet(lParam+Toolbar.NMHDR_size+4,"Int") ; dwItemNext seems to alwys be -1
                b := this.GetButton(this.CmdToIdx(dwItemPrev))
                o.char := char, o.idCmd := dwItemPrev, o.index := b.index, o.label := b.label
            
            Case this.BeginDrag, this.DragOut, this.DeletingButton, this.DropDown: ; NMTOOLBAR struct ; https://docs.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-nmtoolbara
                idCmd := NumGet(lParam,Toolbar.NMHDR_size,"Int")
                b := this.GetButton(this.CmdToIdx(idCmd))
                o.index := b.index, o.idCmd := b.idCmd, o.label := b.label
            
            Case this.EndDrag: ; https://docs.microsoft.com/en-us/windows/win32/controls/tbn-enddrag ; NMTOOLBAR struct, but treat this one differently
                b := {index:0, label:"", icon:0, idCmd:0, styles:0, states:0, iString:-2} ; setup blank button, just in case
                oldIdCmd := NumGet(lParam,Toolbar.NMHDR_size,"Int")                       ; treat iItem as "old ID" becuase it is
                (this.hotItem) ? b := this.GetButton(this.hotItem) : ""                   ; record latest hot item as current index and idCmd
                bOld := this.GetButton(this.CmdToIdx(oldIdCmd))
                o.index := b.index, o.idCmd := b.idCmd, o.label := b.label
                o.oldIdCmd := oldIdCmd, o.oldIndex := bOld.index, o.oldLabel := bOld.label
            
            Case this.HotItemChange, this.DragOver: ; NMTBHOTITEM struct ; https://docs.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-nmtbhotitem
                idOld := NumGet(offset := lParam+Toolbar.NMHDR_size,"Int")
                idNew := NumGet(offset+4,"Int")
                b := this.GetButton(this.CmdToIdx(idNew))
                bOld := this.GetButton(this.CmdToIdx(idOld))
                dwFlags := NumGet(lParam+Toolbar.NMHDR_size+8,"UInt")
                txtFlags := this.GetFlags(dwFlags,"hotItemFlags")
                this.hotItem := b.index, this.hotItemID := b.idCmd
                
                o.index := b.index, o.idCmd := b.idCmd, o.label := b.label
                o.hoverFlags := txtFlags, o.hoverFlagsInt := dwFlags
                o.oldIndex := bOld.index, o.oldIdCmd := bOld.idCmd, o.oldLabel := bOld.label
            
            Case this.KeyDown: ; https://docs.microsoft.com/en-us/windows/win32/controls/nm-keydown-toolbar
                this.NMKEY.nVKEY  := NumGet(lParam+Toolbar.NMHDR_size,"UInt")
                this.NMKEY.uFlags := NumGet(lParam+Toolbar.NMHDR_size+4,"UInt")
                o.vKey := this.NMKEY.nVKEY
            
            ; ===================================================================================
            ; === Customizer Events - these may go away, my custom customizer is better...... ===
            ; ===================================================================================
            
            Case this.EndAdjust: ; * customizer ; https://docs.microsoft.com/en-us/windows/win32/controls/tbn-endadjust
                ; this.btns := this.SaveNewLayout()
            
            Case this.GetButtonInfo: ; * customizer ; https://docs.microsoft.com/en-us/windows/win32/controls/tbn-getbuttoninfo
                iItem := NumGet(lParam+Toolbar.NMHDR_size,"Int")
                If (iItem = this.BtnCount())
                    return false
                
                b := this.GetButton(iItem+1)
                this.Fill_TBBUTTON(lParam, Toolbar.NMHDR_size+A_PtrSize, b.label, b.icon, b.idCmd, b.states, b.styles, b.iString)
                return true
                
            Case this.InitCustomize: ; * customizer ; https://docs.microsoft.com/en-us/windows/win32/controls/tbn-initcustomize
                return 1
            
            Case this.QueryInsert: ; * customizer ; https://docs.microsoft.com/en-us/windows/win32/controls/tbn-queryinsert
                return true
            
            Case this.QueryDelete: ; * customizer ; https://docs.microsoft.com/en-us/windows/win32/controls/tbn-querydelete
                return true
            
            Case this.Reset: ; * customizer ; https://docs.microsoft.com/en-us/windows/win32/controls/tbn-reset
                ; this.Position(this.pos)
                return true
            
            Case this.ToolbarChange: ; * customizer ; https://docs.microsoft.com/en-us/windows/win32/controls/tbn-toolbarchange
                return true
            
            Default:
                this.ResetStructs()
        }
        
        If (o.idCmd) {
            Static RECT := BufferAlloc(16,0)
            r := this.SendMsg(this._GetRect,b.idCmd,RECT.ptr)
            L := NumGet(RECT,"Int"), T := NumGet(RECT,4,"Int"), R := NumGet(RECT,8,"Int"), B := NumGet(RECT,12,"Int")
            o.dims := {x:L, y:T, b:B, w:(R-L), h:(B-T)}
        }
        
        cb := this.callback
        If IsFunc(cb)
            %cb%(this, lParam, o)
    }
    SaveNewLayout() { ; works, but not keeping track of removed buttons yet
        btns := []
        Loop this.SendMsg(this._ButtonCount) {
            b := this.GetButton(A_Index) ; idCmd, iImg, states, styles, width, txt
            btns.InsertAt(A_Index,b)
        }
        return btns
    }
    ResetStructs() {
        this.NMHDR.hwnd:="", this.NMHDR.idFrom:="", this.NMHDR.code:="" ; NMHDR
        this.NMMOUSE.dwItemSpec:="", this.NMMOUSE.dwItemData:="", this.NMMOUSE.pointX:="", this.NMMOUSE.pointY:="", this.NMMOUSE.lParam:="" ; NMMOUSE
        this.NMKEY.nVKEY:="", this.NMKEY.uFlags:="" ; NMKEY
    }
    SendMsg(msg, wParam:=0, lParam:=0) { ; for generic message sending
        return SendMessage(msg, wParam, lParam, this.hwnd)
    }
    IL_Create(ILname, icons, large:=false) {
        handle := IL_Create(icons.Length, 5, large)
        For i, o in icons {
            a := StrSplit(o,"/")
            img := a[1]
            icon := (a.Has(2)) ? a[2] : ""
            If (icon!="")
                IL_Add(handle,img,icon)
            Else IL_Add(handle,img)
        }
        this.ImageLists[ILname] := {handle:handle, files:icons, large:large}
    }
    IL_Add(ILname, icons) { ; append icons to an existing imagelist
        If !this.ImageLists.Has(ILname)
            throw Exception("Image list name doesn't exist: " ILname)
        handle := this.ImageLists[ILname]
        For i, o in icons {
            a := StrSplit(o,"/"), img := a[1], icon := (a.Has(2)) ? a[2] : ""
            If (icon!="")
                IL_Add(handle,img,icon)
            Else IL_Add(handle,img)
            this.ImageLists[ILname].files.Push(o) ; append icons to file list
        }
    }
    IL_Destroy(ILname) {
        handle := this.ImageLists[ILname].handle
        IL_Destroy(handle), this.ImageLists.Delete(ILname)
    }
    SetImageList(Default, Hot := "", Pressed := "", Disabled := "") {
        this.IL_Default := Default, this.IL_Hot := Hot, this.IL_Pressed := Pressed, this.IL_Disabled := Disabled
        result := this.SendMsg(this._SetImageList, 0, this.ImageLists[Default].handle)
        (Hot) ? result := this.SendMsg(this._SetHotImageList, 0, this.ImageLists[Hot].handle) : ""
        (Pressed) ? result := this.SendMsg(this._SetPressedImageList, 0, this.ImageLists[Pressed].handle) : ""
        (Disabled) ? result := this.SendMsg(this._SetDisabledImageList, 0, this.ImageLists[Disabled].handle) : ""
        this.Position(this.pos), this.Position(this.pos)
        
        return result
    }
    
    SetButtonSize(W, H) {
        Long := this.MakeLong(W, H)
        result := this.SendMsg(this._SetButtonSize, 0, Long)
        this.ctrl.Move(,,,H)
        ; this.Position(this.pos), this.Position(this.pos)
        return result
    }
    
    MakeLong(LoWord, HiWord) {
        return (HiWord << 16) | (LoWord & 0xffff)
    }
    
    MakeShort(Long, ByRef LoWord, ByRef HiWord) {
        LoWord := Long & 0xffff,   HiWord := Long >> 16
    }
    
    Customizer() {
        files := this.ImageLists[this.IL_Default].files ; duplicate image list
        large := this.ImageLists[this.IL_Default].large, this.IL_Create("Customizer",files,large)
        
        events := ObjBindMethod(this,"CustoEvents")
        custo := Gui.New("AlwaysOnTop -MinimizeBox -MaximizeBox Owner" this._gui.hwnd,"Customizer")
        LV := custo.Add("ListView","w200 h200 vCustoList Report Checked -hdr",["Icon List"])
        LV.OnEvent("ItemCheck",events)
        LV.ModifyCol(1,170)
        LV.SetImageList(this.ImageLists["Customizer"].handle,1)
        
        btns := this.SaveNewLayout()
        
        For i, b in btns {
            c := !(b.states & Toolbar.states.Hidden) ? " Check" : ""
            LV.Add("Icon" b.icon c, (b.label) ? b.label : "Seperator")
        }
        custo.Add("Button","x+10 yp w100 vMoveUp","Move Up").OnEvent("click",events)
        custo.Add("Button","y+0 w100 vMoveDown","Move Down").OnEvent("click",events)
        custo.Add("Button","y+40 w100 vAddSep","Add Separator").OnEvent("click",events)
        custo.Add("Button","y+0 w100 vRemSep","Remove Seperator").OnEvent("click",events)
        custo.Add("Button","y+45 w50 vOK","OK").OnEvent("click",events)
        custo.Add("Button","x+0 w50 vCancel","Cancel").OnEvent("click",events)
        
        this.btnsReset := this.SaveNewLayout()
        
        custo.Show("hide")
        this._gui.GetPos(x,y,w,h), cX := x+(w//2), cY := y+(h//2)
        custo.GetPos(,,w,h)
        x := cX-(w//2), y := cY-(h//2)
        custo.Show("x" x " y" y)
    }
    CustoEvents(ctl,p*) {
        LV := ctl.gui["CustoList"], r := LV.GetNext()
        If (!r And (InStr(ctl.Name,"move") Or InStr(ctl.Name,"sep")))
            return
        
        If (ctl.Name = "MoveUp" Or ctl.Name = "MoveDown") {
            If (r=1 And ctl.Name="MoveUp") Or (r=LV.GetCount() And ctl.Name="MoveDown")
                return
            newRow := (ctl.Name = "MoveUp") ? r-1 : r+1
            
            b := this.GetButton(r), LV.Delete(r)
            c := !(b.states & Toolbar.states.Hidden) ? " Check" : ""
            LV.Insert(newRow,"Select Icon" (b.icon) c, (b.label) ? b.label : "Seperator")
            LV.Modify(newRow,"Vis")
            
            this.SendMsg(this._MoveButton,r-1,newRow-1)
            
        } Else If (ctl.Name = "Cancel") {
            this.ClearButtons()
            For i, b in this.btnsReset
                this.btnsReset[A_Index].icon -= 1
            this.Add(this.btnsReset,false)
            ctl.gui.Destroy()
        } Else If (ctl.Name = "OK") {
            this.IL_Destroy("Customizer")
            ctl.gui.Destroy()
        } Else If (ctl.Name = "AddSep") {
            this.Insert([{label:""}],r)
            LV.Modify(r,"Select")
            Loop LV.GetCount()
                LV.Modify(A_Index,"-Select")
            LV.Insert(r,"Select Icon0","Seperator")
        } Else If (ctl.Name = "RemSep") {
            If LV.GetText(r) != "Seperator"
                return
            this.SendMsg(this._DeleteButton, r-1)
            btns := this.SaveNewLayout()
            LV.Delete(r)
        } Else If (ctl.Name = "CustoList") {
            item := p[1], checked := p.Has(2) ? p[2] : "" 
            this.HideButton(item,!checked)
        }
    }
    
    class NMHDR {
        hwnd := "", idFrom := "", code := ""
    }
    
    class NMMOUSE {
        dwItemSpec:="", dwItemData:="", pointX:="", pointY:="", lParam:=""
    }
    
    class NMKEY {
        nVKEY:="", uFlags:=""
    }
    Export() {
        btns := this.SaveNewLayout(), a := []
        For i, b in btns {
            props := Map(), props.CaseSense := false
            For prop, value in b.OwnProps()
                props[prop] := value
            a.InsertAt(i,props)
        }
        return a
    }
    Import(a) {
        r := []
        For i, btn in a {
            b := {}
            For prop, value in btn
                (prop = "icon") ? b.%prop% := value-1 : b.%prop% := value
            r.InsertAt(A_Index,b)
        }
        this.Add(r,false)
    }
    ; BtnInfoDisplay(b) { ; idCmd, iImg, states, styles, width, txt
        ; msg := "idCmd: " (b.HasProp("idCmd") ? b.idCmd : "") "`r`n"
             ; . "iImg: " (b.HasProp("icon") ? b.icon : "") "`r`n"
             ; . "states: " (b.HasProp("states") ? b.states : "") "`r`n"
             ; . "styles: " (b.HasProp("styles") ? b.styles : "") "`r`n"
             ; . "width: " (b.HasProp("width") ? b.width : "") "`r`n"
             ; . "txt: " (b.HasProp("label") ? b.label : "") "`r`n"
             ; . "iString: " (b.HasProp("iString") ? b.iString : "") "`r`n"
       ; debug.msg("`r`n" msg)
    ; }
}

