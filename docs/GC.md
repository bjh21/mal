### How can I implement garbage collection in a language that doesn't have it?

Mal doesn't have any way of explicitly freeing memory, so it's
necessary for mal objects to be automatically garbage-collected when
they can't be used any more.  This is easy if the host language
supports garbage collection, since its garbage collector will work
just as well on mal objects as on native ones.  If your host language
doesn't support garbage collection, then you will have to implement it
yourself.

Here is one possible way of doing it.  You will implement a naïve mark
and sweep garbage collector that can run only at the start of `EVAL`.
This restriction means it's not necessary to keep track of every
variable that might hold a mal value, but only those that might be
holding one at the point when the garbage collector is allowed to run.

First, a bit of terminology.  A _mal object_ is any host-language
object that you've allocated to hold a mal value (or part of one).  It
doesn't include mal values that you didn't need to allocate, for
instance if you represent `nil` as a null pointer.  Environments
(introduced in step 3) are
also mal objects, because they need to take part in the
garbage-collection process.

This guide proceeds in parallel with the main guide.  The steps here
are generally deferrable, but an implementation without
garbage-collection will probably not pass the tests for step 5.

#### Step 1

In this step, the garbage-collector can be very simple: it will just
free every allocated object in each iteration of the main loop.

* Create a global list of mal objects, and add each mal object
  to this list when it's created.  This can be a simple single-linked
  list: items will only be removed while we're iterating over the list.

* Add a new function to `types.qx` called `gc_sweep`.  It should have no
  parameters, and should simply walk over the global object list,
  removing each object from the list and freeing it.

* Also in `types.qx`, create a function called `gc_mark`.  It should
  take one parameter and do nothing.

* Create
  another function called simply `gc` that takes a single parameter and
  calls `gc_mark` with that parameter and then calls `gc_sweep`.  This
  is the stub of your garbage collector.

* Put a call to `gc` into the main loop, so that it will get
  called after each call to `rep`.  Pass it a `nil` argument.

The resulting program now frees all the mal objects that it allocates
in each loop, so it shouldn't leak memory any more.  You could
temporarily instrument `gc_sweep` to check that this is happening.

#### Step 2

There are now some mal objects that need to survive a garbage
collection, namely `repl_env` and its contents.  This will require you
to implement most of the rest of the garbage collector.

* Add a flag to each mal object called `gc_marked`.  A newly-created
  object should have this flag clear.

* Add some code to the body of `gc_mark` to process the mal object passed
  as its one parameter.
  If the `gc_marked` flag is set on that
  object, `gc_mark` should return immediately.  If it is clear,
  the function should set the flag and then call `gc_mark` recursively
  on every object referenced by this one.

* Modify `gc_sweep` so that instead of freeing every object, it only
  frees (and removes from the object list) those that have `gc_marked`
  clear.  Where it finds an object with `gc_marked` set, it should clear
  the flag and otherwise leave it alone.

* Adjust the call to `gc` in the main loop to pass `repl_env` as its
  single argument.  This will ensure that the objects referenced from
  `repl_env` are not freed, but everything else is.

#### Step 3

* Extend `gc_mark` to support environments.

At this point the garbage-collector starts to be
properly useful: if you instrument it you should be able to see it
keeping objects while they're referenced by `repl_env` and freeing
them when they're removed.

#### Step 4

The first thing to do here is fairly simple.  Now that functions
can be defined in mal, you need to
ensure that `gc_mark` correctly handles such a function, marking the
parameter list, function body, and environment.  This will probably
preclude using a native closure to represent a function.

Now things get interesting.  In the earlier steps, the amount of
memory that could be allocated in a single pass through the REPL was
quite limited, but with the ability to define functions comes the
ability to do an arbitrary amount of computation, and hence
allocation, in a single expression.  Thus, you need to move the call to
the garbage collector out of the main loop.  Instead, you will put it
at the start of `EVAL`, which is the heart of your LISP interpreter.

Moving the garbage collector into `EVAL` means that you need to start
being a lot more careful about what can be accessed by the program,
and hence what needs to be passed to `gc_mark`.

Obviously at the start of `EVAL`, its two
arguments (`ast` and `env`) will need to be passed to `gc_mark`, but
it's also necessary to mark all the values that might be accessed by
functions that have been called on the way to this invocation of
`EVAL`.  To do this, you'll arrange to maintain a stack of mal objects
that are still accessible.

Add a third parameter to both `EVAL` and `eval_ast`.  Call it
`gc_root`.  Where `rep` calls `EVAL`, it should pass `nil` in this
position, since the only mal objects that are live at this point are
the environment and the expression being evaluated, and those are in
the other two arguments to `EVAL`.

At the start of `EVAL`, construct a new list or vector containing the
three arguments to `EVAL`.  Call this `gc_inner_root`.  Have `EVAL`
call `gc_mark` on `gc_inner_root` and then `gc_sweep`.  Between them,
`ast` and `env` reference everything that this invocation of `EVAL`
can use, while `gc_root` does the same for its callers, so this will
only free objects that are no longer in use.

Now you just need to ensure that every time `EVAL` is invoked, it
gets a correct `gc_root`.  Where `EVAL` calls itself directly, passing
`gc_inner_root` should work.  The only thing to worry about would be
if `EVAL` creates anything itself, but that only applies to the new
environment created by `let*`, and that environment is passed as
`env` to all the inner `EVAL` calls.

Where `EVAL` calls `eval_ast`, have it pass `gc_inner_root` as the
`gc_root` parameter.  When `eval_ast` calls back to `EVAL` it does so
as part of constructing a new list, vector, or hashmap, and it usually
does so more than once.  You need to ensure that when `eval_ast` calls
`EVAL`, any partial results that it's already got are reachable from
`gc_root`.

The final route by which `EVAL` gets called is when the closure
produced by `fn*` calls it.  The value of `gc_root` here needs to be
provided when the closure gets called rather than being captured by
the closure, which in turn means that the "apply" part of `EVAL` needs
to pass `gc_root` to any function that it invokes.  This will require
adding an extra argument to everything that can be applied to take
`gc_root`.  All the existing core functions can ignore this new argument.
The closure constructed by `fn*` should use it, though, and pass it
through to `EVAL`.

You now have a fully working garbage collector.  In the remaining
steps it just needs minor adaptations to keep it working.

#### Step 5

Here, you replace tail-recursive calls to `EVAL` with jumps back to
the start of the function.  In step 4, you passed `gc_inner_root` to
these calls, but that was unnecessary.  Because those calls were it
tail positions, the outer `EVAL` couldn't access any objects after the
return from the inner `EVAL` so you could have passed `gc_root`
instead.  Which conveniently is precisely what happens if you just
leave `gc_root` alone over TCO.

TODO: restructure in terms of steps:

later steps: Make sure that `gc_roots` is properly handled in new
features.

Obviously, `eval`, introduced in step 6, is a way for `EVAL` to call
`EVAL`, but it doesn't allocate anything so there's no work to do
there.  Much the same is true of `swap!`.

`macroexpand`, introduced in step 8 doesn't require any special
effort: it calls `EVAL` but it doesn't allocate anything that needs to
be preserved over that call.

The `try*` form doesn't allocate anything that needs to be preserved
over `EVAL`, but it does require some care to ensure that where it
catches an exception, the state of `gc_roots` is properly unwound to
the state where `try*` was invoked, with any roots that got added on
the way to the exception being removed.

The `apply` core function does nothing special, but `map` is a
different matter.  Like `eval_ast`, it needs to ensure that at each
call to `EVAL`, the list elements that it has accumulated already get
preserved.

That's it!  Step A doesn't add anything special.  You now have a
`gc_roots` that, at the start of each iteration of `EVAL`, can be used
to find every accessible mal object.

Now add a new function, `gc_markall`, that iterates over `gc_roots`
and calls `gc_mark` on each element.

Add a function, `gc_sweep`, that iterates over the list of all objects
and for each one:

* If it's been marked by `gc_mark`, remove the mark.
* If it hasn't been marked, de-allocate it and remove it from the list
  of all objects.

Now at the top of `EVAL` (or the top of the TCO loop), just after
making sure that `ast` and `env` are in `gc_roots`, put in a call to
`gc_markall` and then one to `gc_sweep`.  This should cause your mal
interpreter to stop leaking memory.

Running the garbage collector on every call to `EVAL` is hugely
inefficient.  It's better to only call it occasionally.  A reasonable
approach is to keep track of how much memory (or how many mal objects) are
currently allocated and how many were left after the last
garbage-collection run.  When the current allocations are more than
twice what they were at the end of the last run, it's probably a good
time to run the garbage collector again.
