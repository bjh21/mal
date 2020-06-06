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
core_ns ← core_ns, 'pr-str'      '1↓∊'' '',[1.5]pr_str¨args'
core_ns ← core_ns, 'str'         '(∊pr_str_u¨args),'''''
core_ns ← core_ns, 'prn'         'nil⊣⎕←1↓∊'' '',[1.5]pr_str¨args'
core_ns ← core_ns, 'println'     'nil⊣⎕←1↓∊'' '',[1.5]pr_str_u¨args'
core_ns ← core_ns, 'list'        'args'
core_ns ← core_ns, 'list?'       'B listp↑args'
core_ns ← core_ns, 'empty?'      'B 0=↑⍴,↑args'
core_ns ← core_ns, 'count'       '↑⍴,↑args'
∇x ← eq_prep x
 ⍝⍝ Canonicalise a mal data structure so that APL ≡ correctly implements mal =
 →(~vectorp x)/not_vector
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
core_ns ← core_ns, 'slurp'       '∊(⎕FIO[49]↑args),[1.5]⎕UCS 10'
core_ns ← core_ns, 'atom'        'atom_new↑args'
core_ns ← core_ns, 'atom?'       'B atomp↑args'
core_ns ← core_ns, 'deref'       '⍎(,↑args)'
core_ns ← core_ns, 'reset!'      '⍎(,↑args),''←2⊃args'''
∇result ← fn apply args
 result ← ⍎↑fn
∇
core_ns ← core_ns, 'swap!' '⍎(,↑args),''←(2⊃args)apply(⊂⍎(,↑args)),2↓args'''
core_ns ← core_ns, 'cons'        '(¯1↓args),,↑¯1↑args'
core_ns ← core_ns, 'concat'      '⊃,/,¨args,⊂0⍴0'
core_ns ← core_ns, 'nth'         '(1+2⊃args)⊃,↑args'
core_ns ← core_ns, 'first'       '↑(,↑args),⊂nil'
core_ns ← core_ns, 'rest'        '1↓,↑args'
core_ns ← core_ns, 'throw'       'current_exception←↑args◊''mal exn''⎕ES 101 1'
core_ns ← core_ns, 'apply'       '(↑args)apply(1↓¯1↓args),(↑¯1↑,¨args)'
core_ns ← core_ns, 'map'         '(⊂↑args)apply¨⊂[2]⍪2⊃args'
core_ns ← core_ns, 'nil?'        'B nil≡↑args'
core_ns ← core_ns, 'true?'       'B true≡↑args'
core_ns ← core_ns, 'false?'      'B false≡↑args'
core_ns ← core_ns, 'symbol?'     'B symbolp↑args'
core_ns ← core_ns, 'symbol'      'S↑args'
core_ns ← core_ns, 'keyword'     'K↑args'
core_ns ← core_ns, 'keyword?'    'B keywordp↑args'
core_ns ← core_ns, 'vector'      'V args'
core_ns ← core_ns, 'vector?'     'B vectorp↑args'
core_ns ← core_ns, 'sequential?' 'B(listp↑args)∨(vectorp↑args)'
core_ns ← core_ns, 'hash-map'    'H args'
core_ns ← core_ns, 'map?'        'B mapp↑args'
core_ns ← core_ns, 'assoc' '(H 1↓args),[1](~(H↑args)[;1]∊(H 1↓args)[;1])⌿H↑args'
core_ns ← core_ns, 'dissoc'      '(~(H↑args)[;1]∊1↓args)⌿H↑args'
core_ns ← core_ns, 'get'       '↑(((⊂2⊃args)≡¨(H↑args)[;1])/(H↑args)[;2]),⊂nil'
core_ns ← core_ns, 'contains?'   'B (⊂2⊃args)∊(H↑args)[;1]'
core_ns ← core_ns, 'keys'        '(H↑args)[;1]'
core_ns ← core_ns, 'vals'        '(H↑args)[;2]'
core_ns ← core_ns, 'readline'    '⍞←↑args◊(⍴↑args)↓⍞'
core_ns ← core_ns, 'time-ms'     '24 60 60 1000⊥⎕TS[4 5 6 7]'
core_ns ← core_ns, 'meta'        'error ''meta not implemented'''
core_ns ← core_ns, 'with-meta'   'error ''with-meta not implemented'''
core_ns ← core_ns, 'fn?'         'B fnp↑args'
core_ns ← core_ns, 'string?'     'B stringp↑args'
core_ns ← core_ns, 'number?'     'B numberp↑args'
core_ns ← core_ns, 'seq'    '↑(↑0=⍴,↑args)(stringp↑args)1/nil(,¨↑args)(,↑args)'
core_ns ← core_ns, 'conj'        '⌽(⌽↑args),[1]((⍴⍴↑args)↑(⍴1↓args),1)⍴1↓args'
core_ns ← core_ns, 'macro?'      'B macrop↑args'
core_ns ← core_ns, 'apl-eval'    '(1↑args)apply(1↓args)'

core_ns ← H core_ns
core_ns[;1] ← S ¨core_ns[;1]
core_ns[;2] ← CF¨core_ns[;2]

)SAVE
