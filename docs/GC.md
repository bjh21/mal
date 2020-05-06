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

The first thing to do here is fairly simple.

* Extend `gc_mark` to correctly handle functions defined in mal,
  marking the parameter list, function body, and environment, as well
  as the function itself.  This will probably preclude using a native
  closure to represent a function.

Now things get interesting.  In the earlier steps, the amount of
memory that could be allocated in a single pass through the REPL was
quite limited, but with the ability to define functions comes the
ability to do an arbitrary amount of computation, and hence
allocation, in a single expression.
This means that you need to move the call to
the garbage collector out of the main loop.  Instead, you will put it
at the start of `EVAL`, which is the heart of your LISP interpreter.

Moving the garbage collector into `EVAL` means that it needs to mark
not only the REPL environment but also any mal values referenced by
local variables anywhere in the call stack leading to `gc`.  Or more
precisely, values referenced by local variables that are still _live_,
that is, that might be used in future by the interpreter.

* Add a new parameter to `EVAL` called `gc_root`.

* At the start of `EVAL`, create a mal vector (or list) containing
  `ast`, `env`, and `gc_root`.  Call it `gc_inner_root`, and call
  `gc` passing it `gc_inner_root`.

* Where `EVAL` calls itself recursively, update it to pass `gc_root`
  or `gc_inner_root`:

  * `def!` should pass `gc_inner_root` when evaluating its second
    parameter.
  * `let*` should pass `gc_inner_root` while constructing the new
    environment, but `gc_root` when evaluating the final parameter.
  * `if` should pass `gc_inner_root` when evaluating the condition,
    but `gc_root` when evaluating the second or third parameter.

* Where `rep` calls `EVAL`, have it pass `nil` as `gc_root`.

* Add an extra `gc_root` parameter to the closure produced by `fn*`
  and have that closure pass it on to `EVAL`.

* Also add an extra `gc_root` parameter to every function in
  `core.ns`.  For now, all of them will ignore it.

* Have the default, "apply" case of `EVAL` pass `gc_root` on to the
  function that it calls, whether that's a core function or one
  created by `fn*`.

* Add a `gc_root` parameter to `eval_ast`.

* Where `EVAL` calls `eval_ast` (as part of `do` and when evaluating a
  non-special form), have it pass on `gc_root`.

* In `eval_ast`, when evaluating a list, vector, or hash-map, ensure
  that `ast`, any results returned by previous calls to `EVAL`, and
  any data structure in which you're accumulating such results, are
  retained over each call to `EVAL`.  This will probably require
  constructing a list or vector containing them and `gc_root`, and
  passing that list or vector as `gc_root` in the call to `EVAL`.

You now have a fully working garbage collector.  In the remaining
steps it just needs minor adaptations to keep it working.

#### Step 5

Here, you replace tail-recursive calls to `EVAL` with jumps back to
the start of the function.  All of these calls to `EVAL` should have
kept the same value of `gc_root`, so there's no additional work needed
to set it.

It may look like there's no point in passing `gc_root` to core
functions any more.  Leave it there, though: it will become necessary
again in the next step.

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
