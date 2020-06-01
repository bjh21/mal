)WSID step9_try

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

∇result ← env is_macro_call ast
 result ← (listp ast)∧(symbolp ↑ast)∧(0≠↑⍴(env env_find ↑ast))
 →(∼result)/0
 result ← (macrop env env_get ↑ast)
∇

∇ast ← env macroexpand ast; fn
again:
 →(∼env is_macro_call ast)/0
 fn ← env env_get ↑ast
 args ← 1↓ast
 ast ← ⍎↑fn
∇

∇env env_set_eval kv; key; value
 ⍝⍝ Set environment to value evaluated in that environment.
 ⍝ This is a helper for let*.
 (key value) ← kv
 value ← env EVAL value
 env env_set key value
∇

∇ast←env EVAL ast; op; args; fn; rc; et; r
tco:
 →(listp ast)/do_list
not_list:
 ast ← env eval_ast ast
 →0
do_list:
 →(0=⍴ast)/0
 ast ← env macroexpand ast
 →(∼listp ast)/not_list
 →((S'def!')≢↑ast)/not_def
 x ← env EVAL 3⊃ast
 env env_set (2⊃ast) x
 ast ← x
 →0
not_def:
 →((S'let*')≢↑ast)/not_let
 env ← env env_new (0 2)⍴0
 (⊂env)env_set_eval¨⊂[2]H 2⊃ast
 ast ← 3⊃ast
 →tco
not_let:
 →((S'do')≢↑ast)/not_do
 dummy ← env eval_ast 1↓¯1↓ast
 ast ← ↑¯1↑ast
 →tco
not_do:
 →((S'if')≢↑ast)/not_if
 ast ← ast,⊂nil ⍝ Provide a default 'else' form
 ast ← (3+(⊂env EVAL 2⊃ast)∈false nil)⊃ast
 →tco
not_if:
 →((S'fn*')≢↑ast)/not_fn
 ast ← (1 4)⍴('((⊃fn[1;2])env_new(⊃fn[1;3])bind args)EVAL⊃fn[1;4]'env),ast[2 3]
 →0
not_fn:
 →((S'quote')≢↑ast)/not_quote
 ast ← 2⊃ast
 →0
not_quote:
 →((S'quasiquote')≢↑ast)/not_quasiquote
 ast ← quasiquote 2⊃ast
 →tco
not_quasiquote:
 →((S'defmacro!')≢↑ast)/not_defmacro
 x ← env EVAL 3⊃ast
 →(macrop x)/already_macro
 (↑x) ← '''MACRO''⊢',↑x
already_macro:
 env env_set (2⊃ast) x
 ast ← x
 →0 
not_defmacro:
 →((S'macroexpand')≢↑ast)/not_macroexpand
 ast ← env macroexpand 2⊃ast
 →0
not_macroexpand:
 →((S'try*')≢↑ast)/not_try
 (rc et r) ← ⎕EC 'env EVAL 2⊃ast'
 →(0=rc)/do_catch
 ast ← r
 →0
do_catch:
 r[1;] ⎕ES ((3<⍴ast)/et)  ⍝ Re-throw if there's no catch* clause
 ast ← 3⊃ast
 →((101 1)≡et)/native_exception
 current_exception ← H((K'em') r[1;] (K'et') et)
native_exception:
 env ← env env_new (1 2)⍴(2⊃ast) current_exception
 ast ← 3⊃ast
 →tco
not_try:
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
dummy ← rep '(defmacro! cond (fn* (& xs) (if (> (count xs) 0) (list ''if (first xs) (if (> (count xs) 1) (nth xs 1) (throw "odd number of forms to cond")) (cons ''cond (rest (rest xs)))))))'

∇repl; args; rc; et; r
 args ← ((⎕ARG⍳⊂'--')↓⎕ARG)
 repl_env env_set (S'*FILE*') (↑args)
 repl_env env_set (S'*ARGV*') (1↓args)
 →(0=⍴args)/loop
 dummy ← rep '(load-file *FILE*)'
 ⍝ We'd like to exit here, but I can't find a way to do that.
 →0
loop: (rc et r) ← ⎕EC '⎕ ← rep readline ''user> '''
 →(0≠rc)/loop
 →((1 17)≡et)/0 ⍝ Exit on interrupt
 →((101 1)≡et)/native_exception
 current_exception ← H((K'em') r[1;] (K'et') et)
native_exception:
 'Uncaught exception: ',pr_str current_exception
 →loop
∇

⎕LX ← 'repl'

)SAVE
