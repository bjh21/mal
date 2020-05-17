)WSID step1_read_print

)COPY reader

∇x←READ x
 x←tokenize x
∇
∇x←EVAL x
∇
∇x←PRINT x
 x←1⎕CR x
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
