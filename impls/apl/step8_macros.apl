)WSID step8_macros

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

∇result ← is_pair form
 result ← (0≠↑⍴form)∧(listp form)∨(vectorp form)
∇

∇ast ← quasiquote ast
 →(is_pair ast)/do_pair
 ast ← (S'quote')ast
 →0
do_pair:
 →((S'unquote')≡↑ast)/do_unquote
 →(is_pair ↑ast)/do_pairpair
do_default:
 ast ← (S'cons')(quasiquote ↑ast)(quasiquote 1↓,ast)
 →0
do_pairpair:
 →((S'splice-unquote')≡↑↑ast)/do_splice
 →do_default
do_unquote:
 ast ← ↑1↓,ast
 →0
do_splice:
 ast ← (S'concat')(↑1↓↑ast)(quasiquote 1↓ast)
∇

∇env env_set_eval kv; key; value
 ⍝⍝ Set environment to value evaluated in that environment.
 ⍝ This is a helper for let*.
 (key value) ← kv
 value ← env EVAL value
 env env_set key value
∇

∇ast←env EVAL ast; op; args; fn
tco:
 →(listp ast)/do_list
 ast ← env eval_ast ast
 →0
do_list:
 →(0=⍴ast)/0
 →((S'def!')≢↑ast)/not_def
 x ← env EVAL ⊃ast[3]
 env env_set ast[2], ⊂x
 ast ← x
 →0
not_def:
 →((S'let*')≢↑ast)/not_let
 env ← env env_new (0 2)⍴0
 (⊂env)env_set_eval¨⊂[2]H⊃ast[2]
 ast ← ⊃ast[3]
 →tco
not_let:
 →((S'do')≢↑ast)/not_do
 dummy ← env eval_ast 1↓¯1↓ast
 ast ← ↑¯1↑ast
 →tco
not_do:
 →((S'if')≢↑ast)/not_if
 ast ← ast,⊂nil ⍝ Provide a default 'else' form
 ast ← ⊃ast[3+(⊂env EVAL ⊃ast[2])∈false nil]
 →tco
not_if:
 →((S'fn*')≢↑ast)/not_fn
 ast ← (1 4)⍴('((⊃fn[1;2])env_new(⊃fn[1;3])bind args)EVAL⊃fn[1;4]'env),ast[2 3]
 →0
not_fn:
 →((S'quote')≢↑ast)/not_quote
 ast ← ↑1↓ast
 →0
not_quote:
 →((S'quasiquote')≢↑ast)/not_quasiquote
 ast ← quasiquote ↑1↓ast
 →tco
not_quasiquote:
 ast ← env eval_ast ast
 fn ← ↑ast
 args ← 1↓ast
 →((1 4)≢⍴fn)/not_malfn
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
repl_env env_set (S'eval') (CF'repl_env EVAL↑args')
dummy ← rep '(def! not (fn* (a) (if a false true)))'
dummy ← rep '(def! load-file (fn* (f) (eval (read-string (str "(do " (slurp f) "\nnil)")))))'

∇repl; args
 args ← ((⎕ARG⍳⊂'--')↓⎕ARG)
 repl_env env_set (S'*FILE*') (↑args)
 repl_env env_set (S'*ARGV*') (1↓args)
 →(0=⍴args)/loop
 dummy ← rep '(load-file *FILE*)'
 ⍝ We'd like to exit here, but I can't find a way to do that.
 →0
 loop: '''Error!''◊→(∧/(1 17)=⎕ET)/0' ⎕EA '⎕ ← rep readline ''user> '''
⍝ loop: ⎕ ← rep readline 'user> '
 →loop
∇

⎕LX ← 'repl'

)SAVE
