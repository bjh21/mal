)WSID reader

)COPY types

∇reader_init tokens
 ⍝⍝ fill the reader with tokens
 reader ← tokens
∇

∇next ← reader_next
 ⍝⍝ remove and return the next token from the reader
 next ← reader_peek
 reader ← 1↓reader
∇

∇next ← reader_peek
 ⍝⍝ return the next token without removing it
 error (0=⍴reader)/'Unexpected end of input'
 next ← ↑reader
∇

∇form ← read_str str
 ⍝⍝ convert a string into a mal form
 reader_init tokenize str
 form ← read_form
∇

token_re ← '\G(?:;.*\n|[\s,])*(~@|[\[\]{}()''`~^@]|"(?:\\.|[^\\"])*"?|'
token_re ← token_re,'[^\s\[\]{}(''"`,;)]+)'

∇tokens ← tokenize str
 ⍝⍝ split a string into a vector of tokens
 tokens ← 2⊃¨token_re ⎕RE['g'] ,str
∇

∇form ← read_form; next
 ⍝⍝ extract a form from the reader
 next ← reader_peek
 →((⊂next)≡¨(,'(')(,'[')(,'{'))/do_list do_vector do_hashmap
 →((⊂next)≡¨(,'''')(,'`')(,'~')'~@'(,'@'))/do_quote do_qq do_uq do_suq do_deref
 form ← read_atom
 →0
do_list:
 form ← read_list
 →0
do_vector:
 form ← V read_list
 →0
do_hashmap:
 form ← H read_list
 →0
do_quote:
 next ← reader_next
 form ← (S'quote')(read_form)
 →0
do_qq:
 next ← reader_next
 form ← (S'quasiquote')(read_form)
 →0
do_uq:
 next ← reader_next
 form ← (S'unquote')(read_form)
 →0
do_suq:
 next ← reader_next
 form ← (S'splice-unquote')(read_form)
 →0
do_deref:
 next ← reader_next
 form ← (S'deref')(read_form)
 →0
∇

∇list ← read_list; token; form
 ⍝⍝ extract a list, vector, or hash-map from the reader
 token ← reader_next ⍝ Consume opening '('
 list ← ⍳0
 loop:
  token ← reader_peek
  → ((⊂,token)∊(,')')(,']')(,'}'))/done
  form ← read_form
  list ← list,⊂form
 → loop
 done:
 token ← reader_next ⍝ Consume closing ')'
∇

∇atom ← read_atom; token
 ⍝⍝ extract a number, string, symbol, or keyword from the reader
 token ← reader_next
 → (⍴ '^-?[0-9]+$' ⎕RE token)/evaluate
 → ((⊂token) ∊ 'true' 'false' 'nil')/evaluate
 → (':"'=↑token)/keyword,string
 
 atom ← S token
 →0
keyword:
 token ← 1↓token
 atom ← K token
 →0
string:
 error ('"'≠¯1↑token)/'Unexpected end of input in string'
 token ← ¯1↓1↓token ⍝ Strip quotation marks
 atom ← unescape token
 →0
evaluate:
 atom ← ⍎ token
∇

∇str ← unescape str; qbs
 ⍝⍝ resolve \-escapes in str
 →(0=⍴str)/0                          ⍝ Don't try to process an empty string.
 qbs ← >/¨⌽¨,\'\'=str                 ⍝ 1 for each quoting '\' in token.
 error (¯1↑qbs)/'Unexpected end of input in string'
 (((¯1⌽qbs)∧('n'=str))/str) ← ⎕UCS 10 ⍝ Replace backlashed 'n' with LF.
 str ← (~qbs)/str                     ⍝ Remove quoting backslashes.
∇

)SAVE
