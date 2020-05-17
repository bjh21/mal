## Representations

Numbers are represented by numeric scalars (i.e. numeric arrays of rank zero)

Strings are represented by character vectors (i.e. character arrays of rank 1)

symbols are represented by character arrays of rank 2
keywords are represented by character arrays of rank 3

The ravel-list of a string, symbol, or keyword with the same content
is identical.

mal   | APL
---------------------
"foo" | 'foo'
foo   | 1 3 ⍴ 'foo'
:foo  | 1 1 3 ⍴ 'foo'

Lists are represented by mixed or numeric vectors.

The empty list is an empty numeric (or mixed?) vector.

mal   | APL
-----------
()    | 0⍴1
(7)   | 1⍴7
(8 9) | 8 9

To distinguish a (maybe empty) list x from a string:

' '≡↑0⍴x  ⍝ True iff x is a string

Hash-maps are represented by a two-column matrix, with the keys in the
left column and the values in the right.

mal                       | APL
---------------------------------------------------------
{}                        | 0 2 ⍴ 1
{"foo" 1 "bar" 2 "baz" 3} | 3 2 ⍴ 'foo' 1 'bar' 2 'baz' 3

Construct a hash-map hm from a list l
hm ← (((⍴l)÷2),2)⍴l

Look up 'foo' in hm:
hm[((⊂'foo')≡¨(hm[;1]))⍳1;2]

## Libraries

I think the APL model is that you use )COPY to import from a library
workspace.  We thus use the following model:

types.apl etc are APL input files.  Each one ends with a suitable
)SAVE to produce types.xml etc.

Step files are similar, and can )COPY the library workspaces that they
use.  Each step has a ⎕LX defined that will start it up.

The Makefile runs the .apl files to create the XML workspace files.
Dependencies ensure that the library workspaces are built first.

The run script then uses -L to load the correct workspace.

## Useful character for copy/paste
⍴←≡⎕
⍝

      !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNO
      PQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~¥€⇄∧∼≬⋆⋸⌸⌺⌼μ⍁¡⍣⍅⎕⍞⌹⍆⍤⍇⍈⍊⊤λ
      ⍍⍏£⊥⍶⌶⍐⍑χ≢⍖⍗⍘⍚⍛⌈⍜⍢∪⍨⍕⍎⍬⍪∣│┤⍟∆∇→╣║╗╝←⌊┐└┴┬├─┼↑↓╔╚╩╦╠═╬≡⍸⍷∵⌷⍂⌻⊢⊣◊┘┌█▄▌▐▀⍺⍹⊂⊃
      ⍝⍲⍴⍱⌽⊖○∨⍳⍉∈∩⌿⍀≥≤≠×÷⍙∘⍵⍫⍋⍒¯¨ 

