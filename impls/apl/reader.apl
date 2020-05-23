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
 'Unexpected end of input' ⎕ES (0=⍴reader)/101 1
 next ← ↑reader
∇

∇form ← read_str str
 ⍝⍝ convert a string into a mal form
 reader_init tokenize str
 form ← read_form
∇

token_re ← '\G(?:[\s,]*(~@|[\[\]{}()''`~^@]|"(?:\\.|[^\\"])*"?|'
token_re ← token_re,';.*|[^\s\[\]{}(''"`,;)]+))'

∇tokens ← tokenize str
 ⍝⍝ split a string into a vector of tokens
 tokens ← 2⊃¨token_re ⎕RE['g'] ,str
∇

∇form ← read_form; next
 ⍝⍝ extract a form from the reader
 next ← reader_peek
 →(next≡,'(')/do_list
 →(next≡,'[')/do_vector
 →(next≡,'{')/do_hashmap
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
∇

∇list ← read_list; token; form
 ⍝⍝ extract a list, vector, or hash-map from the reader
 token ← reader_next ⍝ Consume opening '('
 list ← ⍳0
 loop:
  token ← reader_peek
  → ((⊂,token)∈(,')')(,']')(,'}'))/done
  form ← read_form
  list ← list,⊂form
 → loop
 done:
 token ← reader_next ⍝ Consume closing ')'
∇

∇atom ← read_atom; token
 ⍝⍝ extract a number, string, symbol, or keyword from the reader
 token ← reader_next
 → (⍴ '^-?[0-9]+$' ⎕RE token)/number
 → (':"'=↑token)/keyword,string
 atom ← S token
 →0
keyword:
 token ← 1↓token
 atom ← K token
 →0
string:
 'Unterminated string' ⎕ES ('"'≠¯1↑token)/101 2
 token ← ¯1↓1↓token ⍝ Strip quotation marks
 atom ← unescape token
 →0
number:
 atom ← ⍎ token
∇

∇ch ← unescape1 ch
 ⍝⍝ process a single \-escape
 →('n'≠ch)/0  ⍝ Most characters map to themselves
 ch ← ⎕UCS 10 ⍝ But 'n' becomes LF
∇

∇str ← unescape token; bsidx
 ⍝⍝ str is token with the \-escapes removed
 →(∼'\'∈token)/skip ⍝ Don't unescape strings without '\' (GNU APL bug)
 bsidx ← 1+(⊃ '\\.|\\$' ⎕RE['g↓'] token)[;1] ⍝ Indices of quoting '\'
 'Unterminated string' ⎕ES ((⍴token)=¯1↑bsidx)/101 2
 token[1+bsidx] ← unescape1¨token[1+bsidx]   ⍝ Replace escaped chars
 token[bsidx] ← ⊂''			     ⍝ Strip backslashes
skip:
 str ← ∈token 				     ⍝ Flatten
∇

)SAVE
