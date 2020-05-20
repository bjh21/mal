)WSID types

∇result ← listp form
 result ← (' '≢↑0⍴form) ∧ (1=⍴⍴form)
∇

∇result ← vectorp form
 result ← (' '≢↑0⍴form) ∧ (2=⍴⍴form) ∧ (1=¯1↑⍴form)
∇

∇result ← mapp form
 result ← (' '≢↑0⍴form) ∧ (2=⍴⍴form) ∧ (2=¯1↑⍴form)
∇

)SAVE