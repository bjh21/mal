)WSID env

envctr ← 1

∇env ← env_new outer
 ⍝⍝ create a new environment
 ⍝ The guide would have this take two additional arguments specifying
 ⍝ the initial variable bindings, but triadic functions are not very
 ⍝ APLish and it's easy enough to bind variables later:
 ⍝   (⊂env)env_set¨⊂[1]binds,[1.5]exprs
 env ← (⊂('ENV∆',(⍕envctr))),outer
 ⍎(↑env),'←(0 2)⍴0'
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
