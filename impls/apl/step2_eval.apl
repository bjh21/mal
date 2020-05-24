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
 ('''',(,ast),''' not found') ⎕ES (∼∨/(⊂,ast)≡¨env[;1])/101 3
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

∇repl
 loop: '''Error!''◊→(∧/(1 17)=⎕ET)/0' ⎕EA '⎕ ← rep readline ''user> '''
⍝ loop: ⎕ ← rep readline 'user> '
 →loop
∇

⎕LX ← 'repl'

)SAVE