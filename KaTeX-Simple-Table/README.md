### Scripts for simple tables with KaTeX
---
**ahk script usage:**
- create a math block (`ctrl+shift+e` for inline (aligned left) or `/beq` (aligned centre) for block equation)
- type `\table` and wait for it to load
- in `\begin{array}{|l l|}`, `{|l l|}` is the settings for the table
    - press `shift+left` when the table is created to quickly go to this section
    - every letter is a column (`l`, `c` or `r` for different alignments)
    - `|` is a vertical column
    - press `shift+right` or `ctrl+z` to go back to the body of the table (make sure cursor is at the end of the settings)
- press `ctrl+b` to make bold
- press `tab` to create a new column
    - your cursor should be one level inside braces
        - e.g. at `\t{\b{}_}`, not at `\t{\b{_}}`
    - change the script from `{right}` to `{end}` if you probably wouldnt create columns between columns (commented inside the script, at the `tab::` hotkey)
- press `shift+enter` to create a new row
- press `ctrl+enter` to create a new row with a horizontal line
- `ctrl+z` is a sort of pseudo-undo, works if you accidentally created something and want to undo it
- hotkeys stop working once `enter`, `esc` or `alt+tab` is pressed

change the hotkeys if you wish, `^` is ctrl, `+` is shift, `!` is alt, `#` is windows key

default table can also be changed, add or remove some `\hline` or `|` to tweak

compiled version (.exe) for ppl who dont have ahk

**custom css:**
for use with notion enhanced; makes font of `\textsf{}` the same size and typeface
