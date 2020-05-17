)WSID step0_repl

∇x←READ x
∇
∇x←EVAL x
∇
∇x←PRINT x
∇

∇x←rep x
 x←PRINT EVAL READ x
∇

∇line ← readline prompt
 ⍞ ← prompt
 ⍝ When ⍞ is used to prompt for input, the result starts with spaces to
 ⍝ the length of the prompt.  We have to strip those off.
 line ← (⍴ prompt)↓⍞
∇

∇repl
 loop: ⎕ ← rep readline 'user> '
 →loop
∇

⎕LX ← 'repl'

)SAVE
