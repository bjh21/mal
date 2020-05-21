)WSID printer

)COPY types

∇string ← pr_str form; delim
 →(numberp form)/number
 →((symbolp form),(keywordp form))/symbol keyword
 →((listp form)∨(vectorp form)∨(mapp form))/seq
 string ← '<unprintable>'
 →0
number:
 string ← ⍕form
 →0
seq:
 delim ← ↑((listp form),(vectorp form),(mapp form)) / '()' '[]' '{}'
 string ← delim[1],(¯1↓∈(⍪pr_str¨,form),' '),delim[2]
 →0
symbol:
 string ← ,form
 →0
keyword:
 string ← ':',,form
 →0
∇

)SAVE