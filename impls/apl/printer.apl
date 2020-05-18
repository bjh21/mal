)WSID printer

∇string ← pr_str form
 →(2=⍴⍴form)/symbol
 →(1=⍴⍴form)/list
 string ← ⍕form
 →0
symbol:
 string ← ,form
 →0
list:
 string ← '(',(¯1↓∈(⍪pr_str¨form),' '),')'
∇

)SAVE