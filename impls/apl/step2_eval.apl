)WSID step2_eval

)COPY types
)COPY reader
)COPY printer

∇x←READ x
 x←read_str x
∇

∇ast←env eval_ast ast
 →((symbolp ast),(mapp ast),(listp ast)∨(vectorp ast))/do_symbol do_map do_seq
 →0
do_symbol:
 error (∼∨/(⊂,ast)≡¨env[;1])/('''',(,ast),''' not found')
 ast ← ,↑((⊂,ast)≡¨env[;1])/env[;2]
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

repl_env ← 4 2 ⍴ (,'+')'+'  (,'-')('-')  (,'*')('×')  (,'/') ('div')

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
