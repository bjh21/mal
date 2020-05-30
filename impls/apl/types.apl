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
∇result ← atomp form
 ⍝⍝ Return 1 if form is a mal atom (a character 4-cube), 0 otherwise.
 result ← (' '≡↑0⍴form) ∧ (4=↑⍴⍴form)
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
∇result ← fnp form
 ⍝⍝ Return 1 if form is a mal function (a non-character matrix, width ≥3),
 ⍝⍝ 0 otherwise.
 result ← (' '≢↑0⍴form) ∧ (2=↑⍴⍴form) ∧ (3≤¯1↑⍴form)
∇
∇result ← macrop form
 ⍝⍝ Return 1 if form is a mal macro, 0 otherwise.
 result ← (' '≢↑0⍴form) ∧ (2=↑⍴⍴form) ∧ (3≤¯1↑⍴form) ∧ ('''MACRO'''≡7↑↑form)
∇

∇result ← booleanp form
 ⍝⍝ Return 1 if form is a mal boolean (true or false), 0 otherwise.
 result ← (⊂form)≡¨true false
∇
∇result ← nilp form
 ⍝⍝ Return 1 if form is mal nil, 0 otherwise.
 result ← form≡nil
∇

∇symbol ← S string
 ⍝⍝ Reshape a string/symbol/keyword into a symbol
 symbol ← (1,⍴,string)⍴string
∇

∇keyword ← K string
 ⍝⍝ Reshape a string/symbol/keyword into a keyword
 keyword ← (1 1,⍴,string)⍴string
∇

∇vector ← V list
 ⍝⍝ Reshape a list/vector/hash-map into a vector
 vector ← ⍪list
∇

∇hashmap ← H list
 ⍝⍝ Reshape a list/vector/hash-map into a hash-map
 hashmap ← (((⍴,list)÷2),2)⍴list
∇

∇boolean ← B number
 ⍝⍝ Convert an APL boolean (0 or 1) to true or false
 boolean ← 1 1 1 ⍴ number
∇


true ← 1 1 1 ⍴ 1
false ← 1 1 1 ⍴ 0
nil ← 0 0 ⍴ 0

atomctr ← 1

∇atom ← atom_new content
 atom ← 'ATOM∆',(⍕atomctr)
 atomctr ← 1+atomctr
 atom ← (1 1 1,⍴,atom)⍴atom
 ⍎(,atom),'←content'
∇

)SAVE
