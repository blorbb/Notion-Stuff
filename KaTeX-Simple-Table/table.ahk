#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

inTable := False
tableIsNew := False

#Hotstring EndChars `t `t ( ) [ ] , .  - \ / ? ! ;ending character
#Hotstring ? c         ;caps sensitive, within other text


#IfWinActive, ahk_exe Notion Enhanced.exe

:*B0:\table::
Tooltip,
(
b: boxed                 l|l, h`ns: split                     r|l`ng: grid                    |l|l|, h`ncb: custom boxed  | |, h`nc: custom
)
sleep, 50
SetTimer, RemoveToolTip, 500
return

RemoveToolTip:
	Input, var, L1 V,, {enter}{tab}{LControl}{RControl}{LAlt}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}
	Tooltip
return


createTable() {
	global
	inTable := True
	tableIsNew := True
	inSettings := False

	; send table with clipboard (faster than sendinput)
	oldClip := clipboardall
	Clipboard := ""

	While (Clipboard != "")
		Sleep, 10

	clipboard := tableScript

	ClipWait, 2, 1  ; waits until content is found in the clipboard
	send, ^v

	switch tableType {
	Case "boxed":        leftNum := 22
	Case "split":        leftNum := 13
	Case "grid":         leftNum := 22
	Case "custom boxed": leftNum := 35
	Case "custom":       leftNum := 18
	}

	send, {left %leftNum%}  ; go inside the \t{} or settings {} if custom
	sleep, 50
	clipboard := oldClip
	oldClip := ""  ; clear variable to reduce memory
}

; commands for each type of table
::\tableb::
tableType := "boxed"
tableScript := "
(
\def\t#1{\textsf{#1}}\def\b#1{\textsf{\textbf{#1}}}\def\arraystretch{1.4}`n
\begin{array}{|l l|}`n
\hline`n
\t{}`n
\\\hline`n
\end{array}`n
)"
createTable()
input, var, L1 V,,{home}{end}{enter}{Esc}
; ^ var, 1 character and show if typed,, extra keys to detect
if var
	tableIsNew := False
return

::\tables::
tableType := "split"
tableScript := "
(
\def\t#1{\textsf{#1}}\def\b#1{\textsf{\textbf{#1}}}\def\arraystretch{1.4}`n
\begin{array}{r | l}`n
\t{}`n
\end{array}`n
)"
createTable()
input, var, L1 V,,{home}{end}{enter}{Esc}
if var
	tableIsNew := False
return

::\tableg::
tableType := "grid"
tableScript := "
(
\def\t#1{\textsf{#1}}\def\b#1{\textsf{\textbf{#1}}}\def\arraystretch{1.4}`n
\begin{array}{|l | l|}`n
\hline`n
\t{}`n
\\\hline`n
\end{array}`n
)"
createTable()
input, var, L1 V,,{home}{end}{enter}{Esc}
if var
	tableIsNew := False
return

::\tablecb::
tableType := "custom boxed"
tableScript := "
(
\def\t#1{\textsf{#1}}\def\b#1{\textsf{\textbf{#1}}}\def\arraystretch{1.4}`n
\begin{array}{||}`n
\hline`n
\t{}`n
\\\hline`n
\end{array}`n
)"
createTable()
inSettings := True  ; enable shift+right
tableIsNew := False  ; disable shift+left
return

::\tablec::
tableType := "custom"
tableScript := "
(
\def\t#1{\textsf{#1}}\def\b#1{\textsf{\textbf{#1}}}\def\arraystretch{1.4}`n
\begin{array}{}`n
\t{}`n
\end{array}`n
)"
createTable()
inSettings := True  ; enable shift+right
tableIsNew := False  ; disable shift+left
return




#if (inTable == True)
	; turn off when enter, esc or alt tab is pressed
	~enter::inTable := False

	~esc::inTable := False

	~!tab::intable := False

	; create new row
	+enter::
		send, {End} \\+{enter}\t{{}{}}{left}
		recent := "row"
	return

	; create new column
	tab::
		; change {right} to {end} if you probably would not be adding columns between columns
		; ({right} needs cursor to be one level deep in braces)
		; e.g. at underscore \t{\b{}_}, not \t{\b{_}}
		send, {right} & \t{{}{}}{left}
		recent := "column"
	return

	; new row with horizontal line
	^enter::
		send, {end} \\+{enter}\hline+{enter}\t{{}{}}{left}
		recent := "hline"
	return

	; bold
	^b::
		send, \b{{}{}}{left}
		recent := "bold"
	return

	; various undos
	^z::
		switch recent {
			Case "row":    send, {delete}{backspace 7}{left}
			Case "column": send, {delete}{backspace 6}{left}
			Case "hline":  send, {delete}{backspace 14}{left}
			Case "bold":   send, {delete}{backspace 3}
		}
		recent := ""
	return


	; going to \begin{array}{settings here}
	#If (tableIsNew == True and inTable == True)
		+left::
		switch tableType {
			Case "boxed": send, {left 12}
			Case "split": send, {left 5}
			Case "grid":  send, {left 12}
		}
		inSettings := True
		return

	; go back to \t{}
	#If (inSettings == True and inTable == True)
		+right::
		switch tableType {
			Case "boxed":        send, {right 12}
			Case "split":        send, {right 5}
			Case "grid":         send, {right 12}
			Case "custom boxed": send, {right 13}
			Case "custom":       send, {right 5}
		}
		inSettings := False
		return
#if
#IfWinActive