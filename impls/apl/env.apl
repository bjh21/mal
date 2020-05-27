)WSID env

envctr ← 1

∇env ← outer env_new bindings
 ⍝⍝ create a new environment
 ⍝ The guide would have this take separate "binds" and "exprs" specifying
 ⍝ the initial variable bindings, but triadic functions are not very
 ⍝ APLish so this function expects them already laminated together:
 ⍝    ... env_new binds,[1.5]exprs
 env ← (⊂('ENV∆',(⍕envctr))),outer
 ⍎(↑env),'←bindings'
 envctr ← 1+envctr
∇

∇env env_set kv; key; value; data
 ⍝⍝ set a value in an environment
 (key value) ← kv
 data ← ⍎↑env
 data ← ((⊂key)≢¨data[;1])⌿data
 data ← data,[1]kv
 ⍎(↑env),' ← data'
∇

∇p ← frame frame_contains key
 ⍝⍝ does the environment frame named contain the key?
 p ← ∨/(⊂key)≡¨(⍎frame)[;1]
∇

∇env ← env env_find key
 ⍝⍝ find which environment in a chain contains the key
 env ← (∨\env frame_contains¨⊂key)/env
∇

∇value ← env env_get key
 ⍝⍝ get the value of a key in an environment
 env ← env env_find key
 ('''',(,key),''' not found') ⎕ES (0=↑⍴env)/101 3
 value ← ↑((⊂key)≡¨(⍎↑env)[;1])/(⍎↑env)[;2]
∇

)SAVE
