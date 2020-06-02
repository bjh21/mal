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

∇repl; rc; et; r
loop: (rc et r) ← ⎕EC '⎕ ← rep readline ''user> '''
 →(0≠rc)/loop
 →((1 17)≡et)/0 ⍝ Exit on interrupt
 →((101 1)≡et)/native_exception
 current_exception ← H((K'message') r[1;] (K'et') et)
native_exception:
 'Uncaught exception: ',pr_str current_exception
 →loop
∇

⎕LX ← 'repl'

)SAVE
