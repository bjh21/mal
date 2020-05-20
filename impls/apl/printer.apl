)WSID printer

)COPY types

∇string ← pr_str form; delim
 →(' '≡↑0⍴form)/stringish
 →(0<⍴⍴form)/seq
 string ← ⍕form
 →0
seq:
 delim ← ↑((listp form),(vectorp form),(mapp form)) / '()' '[]' '{}'
 string ← delim[1],(¯1↓∈(⍪pr_str¨,form),' '),delim[2]
 →0
stringish:
 →(2=⍴⍴form)/symbol
symbol:
 string ← ,form
 →0
∇

)SAVE