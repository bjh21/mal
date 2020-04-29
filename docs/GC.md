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

This guide prceeds in parallel with the main guide.  The steps here
are generally deferrable, but an implementation without
garbage-collection will probably not pass the tests for step 5.

#### Step 1

In this step, the garbage-collector can be very simple: it will just
free every allocated object in each iteration of the main loop.

Create a global list of mal objects, and add each mal object
to this list when it's created.  This can be a simple single-linked
list: items will only be removed while we're iterating over the list.

Add a new function to `types.qx` called `gc_sweep`.  It should have no
parameters, and should simply walk over the global object list,
removing each object from the list and freeing it.

Put a call to `gc_sweep` into the main loop, so that it will get
called after each call to `rep`.

#### Step 2

There are now some mal objects that need to survive a garbage
collection, namely `repl_env` and its contents.  This will require you
to implement most of the rest of the garbage collector.

Add a flag to each mal object called `gc_marked`.  A newly-created
object should have this flag clear.

Implement a function, `gc_mark`, in `types.qx`, that takes a mal object
as an argument.  If the `gc_marked` flag is set on that
object, it should return immediately.  If it is clear,
the function should set the flag and then call `gc_mark` recursively
on every object referenced by this one.

Modify `gc_sweep` so that instead of freeing every object, it only
frees (and removes from the object list) those that have `gc_marked`
clear.  Where it finds an object with `gc_marked` set, it should clear
the flag and otherwise leave it alone.

Before the call to `gc_sweep` in the main loop, add a call to
`gc_mark`, passing in `repl_env` as its argument.  This will ensure
that objects referenced from it are not freed.

#### Step 3

Step 3 introduces environments, so `gc_mark` needs to be extended to
support them.  At this point the garbage-collector starts to be
properly useful: if you instument it you should be able to see it
keeping objects while they're referenced by `repl_env` and freeing
them when they're removed.

TODO: restructure in terms of steps:

step 4: Move GC calls to `EVAL`, add `gc_roots`.

later steps: Make sure that `gc_roots` is properly handled in new
features.

Now you need to add a data structure (a list or array) called
`gc_roots` to hold all the mal objects that are
directly accessible to the mal program.  This will form a stack, with
entries being added and removed as the mal program executes.  In
general, `gc_roots` should be in the same state on exit from an
interpreter function as it was on entry.  The same mal object can
appear in `gc_roots` multiple times, so it will need to use some
storage separate from the objects themselves.  Making it a linked
list on the stack is one fairly simple approach.

Because the garbage collector will only be called at the start of
`EVAL`, only values that can survive until the next `EVAL` need to be
added to `gc_roots`.
To ensure that we consider all relevant code paths, we'll start at
`EVAL` and trace all paths that might reach `EVAL` again.  In many of
these, the arguments to `EVAL` (`ast` and `env`) will be referenced,
so those should be put into `gc_roots` for the duration of `EVAL`.

The simplest way that `EVAL` can call `EVAL` is through `eval_ast`,
introduced in step 2.  When evaluating elements of a list, vector, or
hash-map, `eval_ast` needs to ensure that the list where evaluated
items are accumulating is in `gc_roots`.

In step 3, `def!` is introduced, but it doesn't directly allocate any
objects and so can be ignored.  `let*` on the other hand allocates a
new environment, so that needs to be preserved.  Happily every call to
`EVAL` from within `let*` passes that as `env`, so it will naturally
be preserved.

Step 4 introduces `if`, which is unproblematic, and `fn*`, which is
slightly less so.  `fn*` doesn't directly cause `EVAL` to invoke
`EVAL`, but each closure that it creates allocates an environment and
invoke `EVAL`, so some analysis is needed.  As with `let*`, though,
that environment is passed to `EVAL`, so no other protection is
needed.

When implementing tail call optimization, you will need to ensure that
the `ast` and `env` in `gc_roots` are replaced when `EVAL` re-starts.

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
