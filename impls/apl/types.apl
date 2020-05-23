)WSID types

∇result ← numberp form
 ⍝⍝ Return 1 if form is a mal number (a numeric scalar), 0 otherwise.
 result ← (0≡↑0⍴form) ∧ (0=↑⍴⍴form)
∇

∇result ← stringp form
 ⍝⍝ Return 1 if form is a mal string (a character vector), 0 otherwise.
 result ← (' '≡↑0⍴form) ∧ (1=↑⍴⍴form)
∇
∇result ← symbolp form
 ⍝⍝ Return 1 if form is a mal symbol (a character matrix), 0 otherwise.
 result ← (' '≡↑0⍴form) ∧ (2=↑⍴⍴form)
∇
∇result ← keywordp form
 ⍝⍝ Return 1 if form is a mal keyword (a character cube), 0 otherwise.
 result ← (' '≡↑0⍴form) ∧ (3=↑⍴⍴form)
∇

∇result ← listp form
 ⍝⍝ Return 1 if form is a mal list (a non-character vector), 0 otherwise.
 result ← (' '≢↑0⍴form) ∧ (1=↑⍴⍴form)
∇
∇result ← vectorp form
 ⍝⍝ Return 1 if form is a mal vector (a non-character matrix, width 1),
 ⍝⍝ 0 otherwise.
 result ← (' '≢↑0⍴form) ∧ (2=↑⍴⍴form) ∧ (1=¯1↑⍴form)
∇
∇result ← mapp form
 ⍝⍝ Return 1 if form is a mal hash-map (a non-character matrix, width 2),
 ⍝⍝ 0 otherwise.
 result ← (' '≢↑0⍴form) ∧ (2=↑⍴⍴form) ∧ (2=¯1↑⍴form)
∇

)SAVE