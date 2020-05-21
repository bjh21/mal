)WSID types

∇result ← numberp form
 result ← (0≡↑0⍴form) ∧ (0=⍴⍴form)
∇

∇result ← stringp form
 result ← (' '≡↑0⍴form) ∧ (1=⍴⍴form)
∇
∇result ← symbolp form
 result ← (' '≡↑0⍴form) ∧ (2=⍴⍴form)
∇
∇result ← keywordp form
 result ← (' '≡↑0⍴form) ∧ (3=⍴⍴form)
∇

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