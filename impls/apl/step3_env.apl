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

∇env env_set_eval kv; key; value
 ⍝⍝ Set environment to value evaluated in that environment.
 ⍝ This is a helper for let*.
 (key value) ← kv
 value ← env EVAL value
 env env_set key value
∇

∇ast←env EVAL ast; op; x; y
 →(listp ast)/do_list
 ast ← env eval_ast ast
 →0
do_list:
 →(0=⍴ast)/0
 →((S'def!')≢↑ast)/not_def
 x ← env EVAL 3⊃ast
 env env_set (2⊃ast) x
 ast ← x
 →0
not_def:
 →((S'let*')≢↑ast)/not_let
 env ← env env_new (0 2)⍴0
 (⊂env)env_set_eval¨⊂[2]H 2⊃ast
 ast ← env EVAL 3⊃ast
 →0
not_let:
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

repl_env ← (0⍴0) env_new (0 2)⍴0
repl_env env_set (S'+') ('+')
repl_env env_set (S'-') ('-')
repl_env env_set (S'*') ('×')
repl_env env_set (S'/') ('div')

∇repl; rc; et; r
loop: (rc et r) ← ⎕EC '⎕ ← rep readline ''user> '''
 →(0≠rc)/loop
 →(1 17≡et)/0 ⍝ Exit on interrupt
 →(101 1≡et)/native_exception
 current_exception ← H((K'message') r[1;] (K'et') et)
native_exception:
 'Uncaught exception: ',pr_str current_exception
 →loop
∇

⎕LX ← 'repl'

)SAVE
