)WSID core

)COPY types

∇cf ← CF str
 cf ← (1 3)⍴str 0 0
∇

∇q ← a div b
 q ← ⌊a÷b
∇

∇result ← prn form
 ⎕ ← pr_str form
 result ← nil
∇

core_ns ← H(S'+')(CF'+/args')(S'-')(CF'-/args')
core_ns ← core_ns,[1]H(S'*')(CF'×/args')(S'/')(CF'div/args')
core_ns ← core_ns,[1]H(S'prn')(CF'prn↑args')
core_ns ← core_ns,[1]H(S'list')(CF'args')
core_ns ← core_ns,[1]H(S'list?')(CF'B listp↑args')
core_ns ← core_ns,[1]H(S'empty?')(CF'B 0=↑⍴,↑args')
core_ns ← core_ns,[1]H(S'count')(CF'↑⍴,↑args')
core_ns ← core_ns,[1]H(S'=')(CF'B∧/2≡/args')
core_ns ← core_ns,[1]H(S'<')(CF'B∧/2</args')
core_ns ← core_ns,[1]H(S'<=')(CF'B∧/2≤/args')
core_ns ← core_ns,[1]H(S'>')(CF'B∧/2>/args')
core_ns ← core_ns,[1]H(S'>=')(CF'B∧/2≥/args')

)SAVE
