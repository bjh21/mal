## Representations

Numbers are represented by numeric scalars (i.e. numeric arrays of rank zero)

Strings are represented by character vectors (i.e. character arrays of
rank 1) or scalars.

symbols are represented by character arrays of rank 2
keywords are represented by character arrays of rank 3

The ravel-list of a string, symbol, or keyword with the same content
is identical.

mal     | APL
--------|------------
`"foo"` | `'foo'`
`foo`   | `1 3 ⍴ 'foo'`
`:foo`  | `1 1 3 ⍴ 'foo'`

Lists are represented by mixed or numeric vectors.

The empty list is an empty numeric (or mixed?) vector.

mal     | APL
--------|------
`()`    | `0⍴1`
`(7)`   | `1⍴7`
`(8 9)` | `8 9`

To distinguish a (maybe empty) list x from a string:

``` apl
' '≡↑0⍴x  ⍝ True iff x is a string
```

Vectors are represented by a column matrix.  A list can be converted
to the corresponding vector by applying `⍪` to it.  A vector can be
converted to a list using `,`.

Hash-maps are represented by a two-column matrix, with the keys in the
left column and the values in the right.

mal                         | APL
----------------------------|--------------------------------
`{}`                        | `0 2 ⍴ 1`
`{"foo" 1 "bar" 2 "baz" 3}` | `3 2 ⍴ 'foo' 1 'bar' 2 'baz' 3`

Construct a hash-map hm from a list l
hm ← (((⍴l)÷2),2)⍴l

Is an element present?
∨/(⊂'quux')≡¨hm[;1]

Look up 'foo' in hm (assuming it's present):
↑((⊂'spoo')≡¨hm[;1])/hm[;2]

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

## Character set

Different APL implementations have different ideas about how to map
the APL character set onto Unicode.  My code follows GNU APL, using
the characters below:

APL name       | Symbol | Unicode code point
---------------|--------|-------------------
up shoe jot    | `⍝`    | U+235D APL FUNCTIONAL SYMBOL UP SHOE JOT
rho            | `⍴`    | U+2374 APL FUNCTIONAL SYMBOL RHO
left arrow     | `←`    | U+2190 LEFTWARDS ARROW
quad           | `⎕`    | U+2395 APL FUNCTIONAL SYMBOL QUAD
quote quad     | `⍞`    | U+235E APL FUNCTIONAL SYMBOL QUOTE QUAD
del            | `∇`    | U+2207 NABLA
right shoe     | `⊃`    | U+2283 SUPERSET OF
dieresis       | `¨`    | U+00A8 DIAERESIS
equal underbar | `≡`    | U+2261 IDENTICAL TO
slash          | `/`    | U+002F SOLIDUS
down tack jot  | `⍎`    | U+234E APL FUNCTIONAL SYMBOL DOWN TACK JOT
up tack jot    | `⍕`    | U+2355 APL FUNCTIONAL SYMBOL UP TACK JOT
epsilon        | `∈`    | U+2208 ELEMENT OF
down arrow     | `↓`    | U+2193 DOWNWARDS ARROW
comma bar      | `⍪`    | U+236A APL FUNCTIONAL SYMBOL COMMA BAR
overbar        | `¯`    | U+00AF MACRON
equal bar slash| `≢`    | U+2262 NOT IDENTICAL TO
up arrow       | `↑`    | U+2191 UPWARDS ARROW

If you want to run it on a different APL implementation, you may need
to translate those characters to different code points.

## Useful characters for copy/paste
⍴←≡⎕⍕⍎≠⊂⊃
⍝∇→

      !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNO
      PQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~¥€⇄∧∼≬⋆⋸⌸⌺⌼μ⍁¡⍣⍅⎕⍞⌹⍆⍤⍇⍈⍊⊤λ
      ⍍⍏£⊥⍶⌶⍐⍑χ≢⍖⍗⍘⍚⍛⌈⍜⍢∪⍨⍕⍎⍬⍪∣│┤⍟∆∇→╣║╗╝←⌊┐└┴┬├─┼↑↓╔╚╩╦╠═╬≡⍸⍷∵⌷⍂⌻⊢⊣◊┘┌█▄▌▐▀⍺⍹⊂⊃
      ⍝⍲⍴⍱⌽⊖○∨⍳⍉∈∩⌿⍀≥≤≠×÷⍙∘⍵⍫⍋⍒¯¨ 

