GLOBAL { readline: ug
         pr_str
         read_str
         init_types; nil; empty; cons; str_setlen; alloc_str; str_bcpl2mal
}

MANIFEST
{
  // The first word of any mal value indicates its type and suchlike.
  // The "supertype" indicates the meaning of the other words of the
  // value.  The "type" distinguishes mal types with the same supertype
  // (for instance functions and macros).
  type = SLCT 8; supertype = SLCT 4

  // Nil. There is a single nil value initialised by init_types(), but
  // it's a valid pointer so it can safely be dereferenced.
  t_nil = #x00

  // Lists.  These are implemented as a linked list.  The empty list,
  // like nil, is a special value.
  t_lst = #x01; lst_first = 1; lst_rest = 2; lst_sz = 3

  // Strings.  Unlike conventional BCPL strings, these have an entire word
  // to store the length.  For compatibility with library routines, the
  // first byte of the string is also the length if it will fit.
  t_str = #x02; str_len = 1; str_data = 2
  maxbcplstrlen = (1 << (BITSPERBCPLWORD / bytesperword)) - 1
}