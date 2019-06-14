GLOBAL { readline: ug
         pr_str
         read_str
         init_types; nil; empty; cons; nth
	 alloc_int
	 str_setlen; alloc_str; str_bcpl2mal; as_sym
	 alloc_vec
	 alloc_cfn
	 empty_hashmap
	 throw
	 catch_level; catch_label; last_exception
	 init_core
}

MANIFEST
{
  // The first word of any mal value indicates its type and suchlike.
  // The "supertype" indicates the meaning of the other words of the
  // value.  The "type" distinguishes mal types with the same supertype
  // (for instance functions and macros).  The compoundflag is set on
  // compund types (ones containing references to other values).
  compoundflag = SLCT 1:7:0; supertype = SLCT 4:4:0; type = SLCT 8:0:0

  // Nil. There is a single nil value initialised by init_types(), but
  // it's a valid pointer so it can safely be dereferenced.
  t_nil = #x00

  // Lists.  These are implemented as a linked list.  The empty list,
  // like nil, is a special value.
  t_lst = #x80; lst_first = 1; lst_rest = 2; lst_sz = 3

  // Integers.
  t_int = #x10; int_value = 1; int_sz = 2
					       
  // Strings.  Unlike conventional BCPL strings, these have an entire word
  // to store the length.  For compatibility with library routines, the
  // first byte of the string is also the length if it will fit.
  t_str = #x20; str_len = 1; str_data = 2

  // Symbols.  Symbols are like strings, but with a different type.
  t_sym = #x21

  maxbcplstrlen = (1 << (BITSPERBCPLWORD / bytesperword)) - 1

  // Vectors.  Structured like strings except that the data consists of
  // pointers rather than packed characters.
  t_vec = #x90; vec_len = 1; vec_data = 2

  // Core functions.  Assumed to take two integer arguments.
  t_cfn = #x30; cfn_fn = 1; cfn_sz = 2

  // Hash-maps.  These are implemented as crit-bit trees.  There are three
  // types of node: internal nodes point to two other nodes and encode a
  // bit offset in the spare bits of the first word.  External nodes
  // point to a key and a value.  Empty nodes describe an empty hash-map.
  t_hmi = #xa0; hmi_left = 1; hmi_right = 2; hmi_sz = 3
  hmi_critbit = SLCT 0:8:0; hmi_maxcritbit = (1 << BITSPERBCPLWORD - 8) - 1
  t_hmx = #xa1; hmx_key = 1; hmx_value = 2; hmx_sz = 3
  t_hm0 = #xb0; hm0_sz = 1
}
