)WSID step1_read_print

)COPY reader
)COPY printer

∇x←READ x
 x←read_str x
∇
∇x←EVAL x
∇
∇x←PRINT x
 x←pr_str x
∇

∇x←rep x
 x←PRINT EVAL READ x
∇

∇line ← readline prompt
 ⍝⍝ show a prompt, read a line, don't return the prompt
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
