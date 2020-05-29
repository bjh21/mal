)WSID core

)COPY types

∇cf ← CF str
 cf ← (1 3)⍴str 0 0
∇

∇q ← a div b
 q ← ⌊a÷b
∇

core_ns ← 0⍴0
core_ns ← core_ns, '+'           '+/args'
core_ns ← core_ns, '-'           '-/args'
core_ns ← core_ns, '*'           '×/args'
core_ns ← core_ns, '/'           'div/args'
core_ns ← core_ns, 'pr-str'      '1↓∈'' '',[1.5]pr_str¨args'
core_ns ← core_ns, 'str'         '(∈pr_str_u¨args),'''''
core_ns ← core_ns, 'prn'         'nil⊣⎕←1↓∈'' '',[1.5]pr_str¨args'
core_ns ← core_ns, 'println'     'nil⊣⎕←1↓∈'' '',[1.5]pr_str_u¨args'
core_ns ← core_ns, 'list'        'args'
core_ns ← core_ns, 'list?'       'B listp↑args'
core_ns ← core_ns, 'empty?'      'B 0=↑⍴,↑args'
core_ns ← core_ns, 'count'       '↑⍴,↑args'
∇x ← eq_prep x
 ⍝⍝ Canonicalise a mal data structure so that APL ≡ correctly implements mal =
 →(∼vectorp x)/not_vector
 x←,x         ⍝ Flatten vectors into lists.
not_vector:
 →((' '≡↑0⍴x)∨(0≠⍴,x))/not_empty
 x←(⍴x)⍴0     ⍝ Make sure all empty lists/vectors/hash-maps have the same type
not_empty:
 →(1≥≡x)/0    ⍝ Scalars and simple lists can be returned unchanged.
 x←eq_prep¨x  ⍝ Otherwise recurse.
∇
core_ns ← core_ns, '='           'B∧/2≡/eq_prep args'
core_ns ← core_ns, '<'           'B∧/2</args'
core_ns ← core_ns, '<='          'B∧/2≤/args'
core_ns ← core_ns, '>'           'B∧/2>/args'
core_ns ← core_ns, '>='          'B∧/2≥/args'
core_ns ← core_ns, 'read-string' 'read_str↑args'
core_ns ← core_ns, 'slurp'       '∈(⎕FIO[49]↑args),[1.5]⎕UCS 10'
core_ns ← core_ns, 'atom'        'atom_new↑args'
core_ns ← core_ns, 'atom?'       'B atomp↑args'
core_ns ← core_ns, 'deref'       '⍎(,↑args)'
core_ns ← core_ns, 'reset!'      '⍎(,↑args),''←↑1↓args'''
∇result ← fn apply args
 result ← ⍎↑fn
∇
core_ns ← core_ns, 'swap!' '⍎(,↑args),''←(↑1↓args)apply(⊂⍎(,↑args)),2↓args'''

core_ns ← H core_ns
core_ns[;1] ← S ¨core_ns[;1]
core_ns[;2] ← CF¨core_ns[;2]

)SAVE
