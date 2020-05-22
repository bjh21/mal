)WSID printer

)COPY types

∇str ← pr_str form; delim
 →(numberp form)/number
 →((stringp form),(symbolp form),(keywordp form))/string symbol keyword
 →((listp form)∨(vectorp form)∨(mapp form))/seq
 string ← '<unprintable>'
 →0
number:
 str ← ⍕form
 →0
seq:
 delim ← ↑((listp form),(vectorp form),(mapp form)) / '()' '[]' '{}'
 str ← delim[1],(¯1↓∈(⍪pr_str¨,form),' '),delim[2]
 →0
string:
 str ← '"',(escape ,form),'"'
 →0
symbol:
 str ← ,form
 →0
keyword:
 str ← ':',,form
 →0
∇

∇escaped ← escape1 ch
 ⍝⍝ \-escape a single character
 escaped ← '\',ch
 → (ch≠⎕UCS 10)/0
 escaped ← '\n'
∇

∇token ← escape str; rpos
 ⍝⍝ \-escape the required characters of str
 rpos ← str∈('\"',⎕UCS 10)
 (rpos/str) ← escape1¨rpos/str
 token ← ∈str
∇

)SAVE
