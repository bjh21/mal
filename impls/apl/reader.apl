)WSID reader

∇reader_init tokens
 reader ← tokens
∇

∇next ← reader_next
 next ← ↑reader
 reader ← 1↓reader
∇

∇next ← reader_peek
 next ← ↑reader
∇

∇form ← read_str str
 reader_init tokenize str
 form ← read_form
∇

token_re ← '\G(?:[\s,]*(~@|[\[\]{}()''`~^@]|"(?:\\.|[^\\"])*"?|'
token_re ← token_re,';.*|[^\s\[\]{}(''"`,;)]+))'

∇tokens ← tokenize str
 tokens ← 1↓¨token_re ⎕RE['g'] str
∇

)SAVE
