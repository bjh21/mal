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
 ⍝ Just as the reader can't yet read backslash escapes, the
 ⍝ printer doesn't yet print them.
 str ← '"',,form,'"'
 →0
symbol:
 str ← ,form
 →0
keyword:
 str ← ':',,form
 →0
∇

)SAVE