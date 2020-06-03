)WSID step5_tco

)COPY types
)COPY reader
)COPY printer
)COPY env
)COPY core

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

∇ast←env EVAL ast; x; args; fn
tco:
 →(listp ast)/do_list
 ast ← env eval_ast ast
 →0
do_list:
 →(0=⍴ast)/0
 →((⊂↑ast)≡¨S¨'def!' 'let*' 'do' 'if' 'fn*')/E_def E_let E_do E_if E_fn
 →E_apply
E_def:
 x ← env EVAL 3⊃ast
 env env_set (2⊃ast) x
 ast ← x
 →0
E_let:
 env ← env env_new (0 2)⍴0
 (⊂env)env_set_eval¨⊂[2]H 2⊃ast
 ast ← 3⊃ast
 →tco
E_do:
 dummy ← env eval_ast 1↓¯1↓ast
 ast ← ↑¯1↑ast
 →tco
E_if:
 ast ← (3+(⊂env EVAL 2⊃ast)∈false nil)⊃ast,⊂nil
 →tco
E_fn:
 ast ← 1 4⍴('((⊃fn[1;2])env_new(⊃fn[1;3])bind args)EVAL⊃fn[1;4]'env),ast[2 3]
 →0
E_apply:
 ast ← env eval_ast ast
 fn ← ↑ast
 args ← 1↓ast
 →(1 4≢⍴fn)/not_malfn
 ast ← ⊃fn[1;4]
 env ← (⊃fn[1;2])env_new(⊃fn[1;3])bind args
 →tco
not_malfn:
 ast ← ⍎↑fn
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

repl_env ← (0⍴0) env_new (0 2)⍴0
(⊂repl_env)env_set¨⊂[2]core_ns
dummy ← rep '(def! not (fn* (a) (if a false true)))'

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
