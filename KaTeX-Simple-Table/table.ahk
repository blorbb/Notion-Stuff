#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

inTable := False
tableIsNew := False

f12::reload

#Hotstring EndChars `t `t ( ) [ ] , .  - \ / ? ! ;ending character
#Hotstring ? c    ;case sensitive, within other text


#IfWinActive, ahk_exe Notion Enhanced.exe
::\table::
	inTable := True
	tableIsNew := True

	; send table with clipboard (faster than sendinput)
	oldClip := clipboardall
	Clipboard := ""

	While (Clipboard != "")
		Sleep, 10

	clipboard := "
	(
\def\t#1{\textsf{#1}}\def\b#1{\textsf{\textbf{#1}}}\def\arraystretch{1.4}`n
\begin{array}{|l l|}`n
\hline`n
\t{}`n
\\\hline`n
\end{array}`n
	)"

	ClipWait, 2, 1  ; waits until content is found in the clipboard
	send, ^v

	send, {left 22}  ; go inside the \t{}
	sleep, 50
	clipboard := oldClip
	oldClip := ""  ; clear variable to reduce memory

	; removes shift+left hotkey once any other key is pressed
	input, var, L1 V,,{home}{end}{enter}{Esc}
	; ^ var, 1 character and show if typed,, extra keys to detect
	if var
		tableIsNew := False
return


#if (inTable == True)
	; turn off when enter, esc or alt tab is pressed
	enter::
		inTable := False
		send, {enter}
	return

	esc::
		inTable := False
		send, {esc}
	return

	!tab::
		intable := False
		send, !{tab}
	return

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
		if (recent == "row")
			send, {delete}{backspace 7}{left}
		else if (recent == "column")
			send, {delete}{backspace 6}{left}
		else if (recent == "hline")
			send, {delete}{backspace 14}{left}
		else if (recent == "bold")
			send, {delete}{backspace 3}
		else if (inSettings == True)  ; alternative to shift right
			send, {right 12}
		recent := ""
	return


	; going to \begin{array}{settings here}
	#If (tableIsNew == True and inTable == True)
		+left::
			send, {left 12}
			inSettings := True
		return

	; go back to \t{}
	#If (inSettings == True and inTable == True)
		+right::
			send, {right 12}
			inSettings := False
		return
#if
#IfWinActive