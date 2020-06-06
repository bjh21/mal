)WSID printer

)COPY types

print_readably ← 1

∇str ← pr_str_u form; print_readably
 ⍝⍝ convert a single mal form into an unreadable string
 ⍝ Rather than having an additional "print_readably" argument to pr_str,
 ⍝ we have this additional entry point.
 print_readably ← 0
 str ← pr_str form
∇

∇str ← pr_str form; delim
 ⍝⍝ convert a single mal form into a string
 →(numberp form)/number
 →((stringp form),(symbolp form),(keywordp form))/string symbol keyword
 →(atomp form)/atom
 →((listp form)∨(vectorp form)∨(mapp form))/seq
 str ← ↑(((⊂form)≡¨true false nil),1)/'true' 'false' 'nil' '<unprintable>'
 →0
number:
 str ← ⍕form
 ((str='¯')/str)←'-'
 →0
seq:
 delim ← ↑((listp form),(vectorp form),(mapp form)) / '()' '[]' '{}'
 str ← delim[1],(1↓∊' ',[1.5]pr_str¨,form),delim[2]
 →0
string:
 → (~print_readably)/symbol
 str ← '"',(escape ,form),'"'
 →0
symbol:
 str ← ,form
 →0
keyword:
 str ← ':',,form
 →0
atom:
 str ← '(atom ',(pr_str ⍎,form),')'
 →0
∇

∇token ← escape str; classes
 ⍝⍝ \-escape the required characters of str
 classes ← ('\"',⎕UCS 10)⍳str
 ((classes=1)/str) ← ⊂'\\'
 ((classes=2)/str) ← ⊂'\"'
 ((classes=3)/str) ← ⊂'\n'
 token ← ∊str
∇

)SAVE
