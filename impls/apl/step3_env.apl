)WSID step3_env

)COPY types
)COPY reader
)COPY printer
)COPY env

∇x←READ x
 x←read_str x
∇

∇ast←env eval_ast ast
 →((symbolp ast),(mapp ast),(listp ast)∨(vectorp ast))/do_symbol do_map do_seq
 →0
do_symbol:
 ast ← env env_get ast
 →0
do_seq:
 ast ← (⊂env)EVAL¨ast
 →0
do_map:
 ast[;2] ← (⊂env)EVAL¨ast[;2]
∇

∇ast←env EVAL ast; op; x; y
 →(listp ast)/do_list
 ast ← env eval_ast ast
 →0
do_list:
 →(0=⍴ast)/0
 →(((1 4)⍴'def!')≢↑ast)/not_def
 x ← env EVAL ⊃ast[3]
 env env_set ast[2], ⊂x
 ast ← x
 →0
not_def:
 ast ← env eval_ast ast
 (op x y) ← ast
 ast ← ⍎ 'x ',op,' y'
∇

∇x←PRINT x
 x←pr_str x
∇

∇x←rep x
 x←PRINT repl_env EVAL READ x
∇

∇line ← readline prompt
 ⍝⍝ show a prompt, read a line, don't return the prompt
 ⍞ ← prompt
 ⍝ When ⍞ is used to prompt for input, the result starts with spaces to
 ⍝ the length of the prompt.  We have to strip those off.
 line ← (⍴ prompt)↓⍞
∇

∇q ← a div b
 q ← ⌊a÷b
∇

repl_env ← env_new ⍳0
repl_env env_set ((1 1)⍴'+') ('+')
repl_env env_set ((1 1)⍴'-') ('-')
repl_env env_set ((1 1)⍴'*') ('×')
repl_env env_set ((1 1)⍴'/') ('div')

∇repl
⍝ loop: '''Error!''◊→(∧/(1 17)=⎕ET)/0' ⎕EA '⎕ ← rep readline ''user> '''
 loop: ⎕ ← rep readline 'user> '
 →loop
∇

⎕LX ← 'repl'

)SAVE
