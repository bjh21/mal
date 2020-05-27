)WSID core

)COPY types

∇cf ← CF str
 cf ← (1 3)⍴str 0 0
∇

∇q ← a div b
 q ← ⌊a÷b
∇

core_ns ← 0⍴0
core_ns ← core_ns, '+'      '+/args'
core_ns ← core_ns, '-'      '-/args'
core_ns ← core_ns, '*'      '×/args'
core_ns ← core_ns, '/'      'div/args'
core_ns ← core_ns, 'pr-str' '1↓∈'' '',[1.5]pr_str¨args'
core_ns ← core_ns, 'prn'    'nil⊣⎕←1↓∈'' '',[1.5]pr_str¨args'
core_ns ← core_ns, 'list'   'args'
core_ns ← core_ns, 'list?'  'B listp↑args'
core_ns ← core_ns, 'empty?' 'B 0=↑⍴,↑args'
core_ns ← core_ns, 'count'  '↑⍴,↑args'
core_ns ← core_ns, '='      'B∧/2≡/args'
core_ns ← core_ns, '<'      'B∧/2</args'
core_ns ← core_ns, '<='     'B∧/2≤/args'
core_ns ← core_ns, '>'      'B∧/2>/args'
core_ns ← core_ns, '>='     'B∧/2≥/args'

core_ns ← H core_ns
core_ns[;1] ← S ¨core_ns[;1]
core_ns[;2] ← CF¨core_ns[;2]

)SAVE
