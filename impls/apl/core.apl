)WSID core

)COPY types

∇cf ← CF str
 cf ← (1 3)⍴str 0 0
∇

∇q ← a div b
 q ← ⌊a÷b
∇

core_ns ← 0⍴0
core_ns ← core_ns, '+'       '+/args'
core_ns ← core_ns, '-'       '-/args'
core_ns ← core_ns, '*'       '×/args'
core_ns ← core_ns, '/'       'div/args'
core_ns ← core_ns, 'pr-str'  '1↓∈'' '',[1.5]pr_str¨args'
core_ns ← core_ns, 'str'     '(∈pr_str_u¨args),'''''
core_ns ← core_ns, 'prn'     'nil⊣⎕←1↓∈'' '',[1.5]pr_str¨args'
core_ns ← core_ns, 'println' 'nil⊣⎕←1↓∈'' '',[1.5]pr_str_u¨args'
core_ns ← core_ns, 'list'    'args'
core_ns ← core_ns, 'list?'   'B listp↑args'
core_ns ← core_ns, 'empty?'  'B 0=↑⍴,↑args'
core_ns ← core_ns, 'count'   '↑⍴,↑args'
∇x ← listify x
 ⍝⍝ Return x with all (mal) vectors converted to lists
 →(∼vectorp x)/not_vector
 x←,x         ⍝ Flatten vectors into lists.
not_vector:
 →(1≥≡x)/0    ⍝ Scalars and simple lists can be returned unchanged.
 x←listify¨x  ⍝ Otherwise recurse.
∇
core_ns ← core_ns, '='       'B∧/2≡/listify args'
core_ns ← core_ns, '<'       'B∧/2</args'
core_ns ← core_ns, '<='      'B∧/2≤/args'
core_ns ← core_ns, '>'       'B∧/2>/args'
core_ns ← core_ns, '>='      'B∧/2≥/args'

core_ns ← H core_ns
core_ns[;1] ← S ¨core_ns[;1]
core_ns[;2] ← CF¨core_ns[;2]

)SAVE
