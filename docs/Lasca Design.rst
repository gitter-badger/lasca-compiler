==========================
Lasca Programming Language
==========================
.. class:: center

Lasca Programming Language Design Draft v0.0.1

Simple yet powerful modern functional programming language.


.. contents::

Overview
========

- strict
- functional
- expression based
- pattern matching
- no null
- strongly statically typed with type inference, and dynamic modes
- System F with liquid types (`Liquid Haskell`_)
- type inference (Hindley-Milner alike)
- type o (Haskell), or implicit instances (Idris)
- syntactic sugar for function application (named arguments, defaults, method calls), lenses, records, indexed access,
  applicatives and monads (do-notation).
- multiple type checking passes (types, side-effects/purity checks, totality checks, big O checks?)
- immutable data by default
- persisted data structures (see [1]_, [2]_)
- message passing concurrency (see Erlang_ actors, Akka_) (or CPS like in Go?)
- batteries included (json, lenses, collections, vars, actors)
- LLVM_ backend
- JS backend
- REPL


Inspired by: Scala, Haskell, Idris, OCaml/SML, Clojure, Erlang, Julia, Ruby, Python, Haxe, Go, Rust, D, Pony_

Domain
======

* Highly concurrent applications (P2P, blockchain)
* Distributed server side applications development
* Machine learning tasks
* Web development

Goals – substitute Go, Erlang, Scala/Scala.js, Python, Julia and JavaScript/Node.js for server-side development.


Motivation
==========

You write code once and read it hundred times.

Hence, readability and simplicity but expressivity and conciseness is the essence.
One of the goal is to speed-up and partition a usual development cycle:

	change -> get result

	prototype -> get fast result -> improve code -> test -> produce optimized program

Compilation time matters. A lot. 
 
To speed-up prototyping I suggest simplify disable/simplify typechecking during prototyping.
This can be done by compiler option with per source file, or even per definition granularity.

See `Haskell Defered type checking`_.

Future of Programming by Uncle Bob Martin
https://www.youtube.com/watch?v=ecIWPzGEbFc

Resume
- Lisp for the rescue



https://www.quorumlanguage.com/evidence.html

The Programming Language Wars
https://www.youtube.com/watch?v=bvtD8Bg8Dv0

http://web.cs.unlv.edu/stefika/research.html

Resume
- static typing is generally better
- documentations matters
- ide doesn't matter o_O

https://www.quorumlanguage.com/evidence.html

http://dl.acm.org/citation.cfm?id=2962592

TDD is bullshit

Human perception driven approach for a programming language syntax design
-------------------------------------------------------------------------

Lambda-calculus, and Haskell are great for a compiler. Not so much for a human.
People are not computers. Yet, at least.

We must consider human perceptive characteristic designing the language syntax.

For example, at least for me, it's very important to get some working result as quick as possible.
That means I would rather not wait for compilation/type checking/tests/system startup.
Hence, either all of that happen very quickly, or we need to postpone/disable some of that.

We can postpone compilation/typechecking, run in interpreter mode and do jitting.
We can do a gradual typecheck, run in interpreter mode and do jitting.

When things are getting... TODO

Programme Lifecycle
-------------------

Prototyping
   - Require fastest change-run cycles, it's very important!
   - Don't care about types, compilation errors in other packages.
   - If it can be run, it should be run. (JavaScript mode :)

Settlement
   - Things are getting cleaner, APIs can be seen and refactored.
   - Here we need a typechecker. Mostly in IDE, suggesting things.
   - You can define and polish your tests.

Production
   - All API have a valid documentation with examples and tests.

Continuous Integration
   - Builds are made with all type/style checks, tests runs, and optimizations enabled.

Critical Software
   - Refinement types proofs, Effects proofs.

Maintenance
   - Navigation support is crucial.
   - Readability is crucial.
   - Avoid complex concepts: HKT, implicits, operators.

Refactoring
   - IDE support!


Entropy
-------

- Entropy must be in "perceptive" range.
- Not too much of duplication.
- Not too much of entropy

Too much entropy:

.. code:: haskell

	foldl :: (a -> b -> a) -> a -> [b] -> a
	foldl f z []     = z
	foldl f z (x:xs) = foldl f (f z x) xs

Better:

.. code:: scala

	def foldLeft[A, B](col: List[A], z: B, f: (B, A) => B): B =
	  (col, z, f) match {
		case (Nil, z, f) => z
		case (x :: xs, z, f) => xs.foldLeft(z, f(z, x))
	  }

Optimal?

.. code:: scala

	def foldl(col: Seq a, zero: z, f: z -> a -> z): a = match
	  [] zero _        -> zero
	  (x :: xs) zero f -> xs.foldl zero (f zero x)
	end

Vision
======

You get a multipurpose modern programming language.

When you need to write a shell script or quickly prototype an idea – use gradual typing mode and interpretation.

When you need speed – compile before use, types are inferred

When you need speed and correctness – compile and validate your liquid types with CVC4/Z3 solvers.


Probelms And Solutions
======================

Undetermined Control Flow With Existence of Exceptions
	Lasca don't have exception.

Dimond Problme of Multiple Inheritance
	Lasca don't have multiple inheritance of data

If-branching complexities
	Lasca have a pattern matching and/or Applicative/Monad comprehensions (do-blocks)

Lasca don't have overloading
	Instead it has name and default arguments, and ADTs which solve the problem quite well

Immutable data is slow to modify
	Lasca will try to find places where immutable data is local and is linear and will modify data in-place.
    ???



Type System
===========

Gloals
------

What type systems are for

#. Find type errors at compile time (can't pass Int where String is expected)
#. Help IDE with suggestions
#. Optimal code generation:

	- memory alignment
	- on stack allocation
	- life-time tracking with linear types
	- array bounds checks elimination
	- other runtime checks elimination
	- vectorization

#. Correctness
#. Side effects control

	- why? what benefits?

Our goal is to get the best from type system while not making it too complex and intrusive.

Switchable gradual/static typing. Both are strong.

System F with Liquid Types. (see `Liquid Haskell`_, Leon_)

Type classes (Haskell or Idris like implicits).

Discussion
~~~~~~~~~~

- `Edward Kmett - Type Classes vs. the World <https://www.youtube.com/watch?v=hIZxTQP1ifo>`_
- `Scrap your type classes <http://www.haskellforall.com/2012/05/scrap-your-type-classes.html>`_

Thoughts on Subtyping
~~~~~~~~~~~~~~~~~~~~~

Implementing data Subtyping implies

- variance
- complex typer
- protected visibility
- least upper bound for if/case

Consider not having subclassing at all.

Will have type classes subtyping, and liquid types subtyping.


Syntax
======

- curly-braced blocks
- prefered camel case naming (Java style)
- limited set of definable operators
- Scala-like imports
- Haskell if/then/else
- var inside a function
- method syntax

Curly Braces vs Indentation
---------------------------

https://www.quora.com/What-are-the-downsides-to-whitespace-indentation-rather-than-requiring-curly-braces

#. No auto formatting for indentation based code.
#. Whitespace indentation makes code generation unnecessary hard.
   It is a lot easier to generate your structural code in whatever way that is easier for machine to read and
   let some post-processor format it nicely for human to read.
#. While doing a merge in Perforce/SVN/CVS, it's quite easy to unintentionally remove/introduce whitespaces
   (especially quite easy when you come from a background where whitespaces do not matter -
   for example, a Java developer changing a small piece of Python code)
#. Its much easier to copy code from one place to another if the whitespaces and indentation do not matter
#. Tabs and spaces are easy to mix-up.
   If your tab-length is 4 spaces, an indentation of 1 tab and 4 spaces will look the same.
   However, Python distinguishes between the two. You will struggle to find where the error in your code is,
   because the indentation "looks" uniform everywhere but isn't.
#. Vim allows easy navigation with curly brackets.
   Just navigate to the opening (closing) curly bracket and press '%'
   and you will be taken to the closing (opening) curly bracket. No such thing for Python.
#. Let's say you had a huge block of code in a try-catch. It would naturally be indented by (say) 1 tab more than the code outside it. Now if you want to remove the try statement, have fun removing the indentation on the huge block of code in it (if it were curly braces, simply commenting those out would do the job).
#. Conversely to point 4, adding a block of code in between is also troublesome (points 4 and 5 are mentioned in the context of code development, where you might not be sticking firmly to how the code looks. Let's say you wanted to just add/modify a block of code to see what difference it made).
#. Again, as the number of lines in the code increases, the fear that some indentation has gone wrong somewhere builds up drastically. It can also be extremely difficult to figure out where the indentation has gone wrong.
#. As the end of a block is not defined using a non-white space character, block endings should be coded carefully, lest you mistakenly put the last statement outside the indented block. With curly braces, the chances of this are low because visually there's a concrete block-ending character.

Keywords
--------
``alias``?, ``and``, ``as``?, ``break``?, ``case``?, ``continue``?, ``data``,
``def``,
``extend``?,
``extern``,
``for``?,
``if``,
``import``,
``infix``?, ``infixl``?, ``infixr``?
``instance``/``impl``?,
``let``?,
``macro``?,
``match``?,
``not``
``or``
``package``,
``private``?,
``struct``?,
``then``,
``trait``,
``type``,
``use``?,
``val``?,
``var``,
``while``,
``where``?,
``xor``
``yield``?,

``implicit``? (better with annotation if needed)

``class``? – no. ambiguous with OOP class. Use trait instead.

``fn``, ``fun``, ``func``? – no, use ``def``.
We may consider it a logical judgmental at some point, so let a function be a definition.

Identifiers Names
-----------------

Disallow [-_'] symbols in plain identifiers.
Functions and val/vars should start with a lowercase letter and must not contain underscores etc.
If it's required for some reason, use back-ticks (as in Scala):

Type names start with uppercase letter. Same rules apply.

.. code:: haskell

	`arbitrary ident_name with keywords import` = 1

	type OptString = Option String


Basic Types
-----------

Not decided yet.

Numbers
~~~~~~~

Not sure about naming. Either

- ``I8``/``U8``/``Byte``, ``I16``/``U16``/``Short``, ``I32``/``U32``/``Int``, ``I64``/``U64``/``Long``, ``F32``, ``F64``
- ``Byte``/``UByte``, ``Short``/``UShort``, ``Int``/``UInt``, ``Long``/``ULong``, ``Float32``, ``Float64``/``Double``
- ``Integer``/``BigInt``/``Decimal``/whatever for unlimited precision numerals
- maybe have ``Int`` be the size of target machine word?

Do we need unsigned types?

.. code:: haskell

	type Nat = { i: Int | i >= 0 } -- Natural numbers

Bool
~~~~

Consider Bool as ADT defined in Prelude.

.. code:: haskell

	data Bool = True | False

Char And String
~~~~~~~~~~~~~~~

Consider not having separate Char type.

Java, JavaScript use UCS-2 2 byte Unicode code point representation.
That used to be OK, but know we have more than 65536 code points and they can't be represented by a single 16-bit word.
So a code point must be represented with UTF-32, 32-bit unsigned word. (U32/UInt32/UInt you name it).

So, default ``String`` type is a UTF-8 encoded Unicode string.


Compound Types
--------------

- algebraic data types (Haskell like)

.. code:: haskell

	data Bool = True | False

- GADT

.. code:: haskell

	data Expr a = IntVal(value: Int): Expr Int | StringVal(value: String): Expr String

- records

.. code:: haskell

	data Point a = Point(x: a, y: a)

	data Point(x: Int, y: Int) -- syntax sugar.

	data Person {
		firstName: String
		secondName: String
		age: Nat
	}

    val p = Person "Alex" "Nemish" 33
    val p = Person("Alex", "Nemish", 33)
    val p = Person(firstName = "Alex", secondName = "Nemish", age = 33)
    val p = Person { firstName = "Alex", secondName = "Nemish", age = 33 }

    Person.firstName p == p.firstName

	-- ADTs/GADTs
	data List(a) = Nil | Cons(head: a, tail: List(a))
	type List(a) = Nil | Cons (head: a, tail: List(a))
	type List(a) = Nil | Cons { head: a, tail: List(a) }

	-- GADT
	data Expr(a) = Unit: Expr(a) | Iadd (l: Int, r: Int): Expr(Int) | Isub (l: Int, r: Int): Expr(Int)

	-- Traits/Interfaces/Type classes
	trait Functor(F) {
		-- pure
		def map(c: F(a), f: a => b): F(b)
	}

	instance Functor(List) {
		-- pure, O(c.size), total
		def map(c, f) = {
		  (Nil, f) => Nil
		  (x::xs, f) => Cons(f(x), xs.map(f))
		  (x::xs, f) => Cons(f x, xs.map f)
		  (x::xs, f) => Cons (f x) (xs.map f)
		}
	}



Data derives ``(ToString, Eq, Hash, Json)`` by default.


Method syntax
-------------

Dot syntax implies passing prefix as a called function first argument.
It's more familiar and intuitive for a programmer. May simplify adoption.

#. ``1.toString`` <=> ``toString 1``
#. ``1.plus 2`` <=> ``plus 1 2``
#. ``a.b.c.d e f.g`` <=> ``d (c (b a)) e (g f)``

Call syntax
-----------

I'm thinking on mixing applicative function call syntax with argument list call syntax, and method syntax calls.
And make it possible to use implicitly tupled functions, like



.. code:: haskell

	def foo(a: Int, b: String = "zero"): Bool

    foo 1 "one"
    foo(1, "one")
    foo(1) -- foo 1 "zero"
    foo(b = "one", a = 1) -- foo 1 "one"
    foo 1 -- partial application
    1.foo -- foo 1 "zero"
    1.foo "one" -- foo 1 "one"
    1.foo("one") -- foo 1 "one"
    1.foo(b = "one") -- foo 1 "one"


Pattern Matching
----------------

def test: (Person, Point) = ??? end

test match
    (Person "Alex sn age, Point x y) if age > 30 =>
    (Person fn sn age, Point 0 0) =>
end


Lens And Immutable Data Structures
----------------------------------
.. code:: ruby

	data Vector(a: Point, b: Point, c: Point)

    v = Vector Point(0, 0) Point(1, 1) Point(2, 2)
    v1 = v.a.x := 1 --> Vector(Point(1, 0), Point(1, 1), Point(2, 2))
    v1 = v.a.x ~= { _ + 1 } --> Vector(Point(1, 0), Point(1, 1), Point(2, 2))



Donts
-----

Discourage point-free expressions!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

From https://wiki.haskell.org/Pointfree


	Pointfree Style
		It is very common for functional programmers to write functions as a composition of other functions,
		never mentioning the actual arguments they will be applied to. For example, compare:

		 .. code:: haskell

			sum = foldr (+) 0

		with:

		 .. code:: haskell

			 sum' xs = foldr (+) 0 xs

		These functions perform the same operation, however, the former is more compact,
		and is considered cleaner. This is closely related to function pipelines (and to unix shell scripting):
		it is clearer to write let fn = f . g . h than to write let fn x = f (g (h x)).


I find this style extremely non-intuitive, hard to read, understand, and maintain.
Saving few characters doesn't worth it.

Operators
---------

Provide a limited set of redefinable operator with forced laws to satisfy.

- ``+``, ``*`` – commutative, associative binary operation
- ``-``, ``/`` – associative binary operation
- ``++`` – associative binary operation ``append``
- ``::`` – list cons
- ``!`` – binary operation (actors?)
- ``?`` – binary operation

Comments
--------

Inline comment
	Consider ``--`` or ``#`` or ``//``. I prefer ``--`` because it's less visually noisy.
	When used after a code line it looks like a hyphen.

.. code:: scala

	doStuff() -- this call does stuff
	doStuff() # this call does stuff
	doStuff() // this call does stuff

Block comment
	- Consider: ``/* */``, ``{- -}``, ``""" """``
	- Must be nestable! It's much easier to comment a code with comments.

Comment-based extensions
~~~~~~~~~~~~~~~~~~~~~~~~

Annotate things in comments, e.g. Haskell-like Liquid type annotations etc.
   
This allows to compose a general textual comment about a function/type with semantically significant informations, 
like liquid types annotations, totality, purity, big O annotations.

Visibility
----------

Options:

#. Export all/explicit export of functions and types at module definition (Haskell, Erlang etc)
#. Name-dependent visibility. E.g if an identifier starts with lowercase/__ letter(s) that it's private. (Go, Python)
#. Public by default, explicit ``private`` keyword to make a function/type private. (Scala)

I'd like to disallow ``_`` in identifier names, and distinguish functions and types by first lowercase/uppercase letter.

Public by default. Explicit ``private`` keyword.

Ideas
-----

.. code:: scala

	def main = {
	-- if
		if 0 <= idx < 10 and array(idx) > 0 then a else b -- Chaining comparisons (Julia, Python)
		if true then dostuff() <=> if true then { dostuff(); () } else ()
	-- Streams, Lists, List comprehension
		list = [1, 2, 3]
		list = [x | x <- 1..10 if x < 3, y <- 1..20 if y - x > 0]
	-- Lambda
		func = { () => 1 }
		func = { () => 1 }
		func = { () -> 1 }
		func = { -> 1 }
		func = { x => x + 1 }
		func = { x -> x + 1 }
		func = { (x, y) => x + y }
		func = { (x, y) -> x + y }
		hof = list.map { _ + 1 } <=> map list { x => x + 1}
		hof = list.map { x => x + 1 }
		hof = list.collect { (x, y) if x > 0  => x + y } -- like Scala case, but without ``case`` keyword
		func = x => { x + 1 }
	-- Map literal
		a = "a"
		one = 1
		dict  = { a: one, "a": 1, "b": 2 }
		dict2 = [ a = one, "a" = 1, "b" = 2, "c" = 3 ]
		dict2 = [ a = one | (a, one) <- genTuples if a > one ]
		dict2 = Map [ a = one | (a, one) <- genTuples if a > one ]
		dict2 = [ a: one, "a" : 1, "b" => 2, "c" => 3 ]
		dict  = { a => one, "a" => 1, "b" => 2, "c" => 3 }
		dict2 = [ a => one, "a" => 1, "b" => 2, "c" => 3 ]
		dict3 = Map [ (a, one), ("a", 1), ("b", 2), ("c", 3) ] -- Haskell-like. Most reasonable
	-- Pattern matching
		patmat = array match {
		  a: Int => false
		  [1, 2, 3] => true
		  Cons(x, _) =>
		  {k: v, _} => false
		  r@ 1..3 => true
		  1 | 2 | 3 => true
		  x if x > 0 => false
		}

	-- Chaining comparisons (Julia, Python)
	   1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5


	-- Everything is {}
	-- Lambda
	   val lam = { x => x + 1 }
	   val patLambda = { (Context x _) value => value + x }
	   val patMat = {
		 (Context x None)   value          => value + x
		 (Context _ Some(y) value if y > 0 => value + y
		 (Context _ Some(y) value          => value + y + 1
	   }
	-- do block
	  val list = [1 .. 3]
	val doubled = do { i <- list; pure (i * i) } -- [1, 4, 9]
	}

Code Example
------------

.. code:: scala

	package test

	import something.{Data => D}, D._

	pi: Float64 = D.pi

	def len(d) = d * pi

	def len(Num n => d: n): Float64 = d.toFloat64 * pi

	-- {d: n | d > 0 }
	def len (Num n => d: n): Float64 = d.toFloat64 * pi

	-- arguments are either inferred or dynamicly typed
	-- { x: Int, y: Int, z: List Int | size z > 0 and x + y > 0 }
	def example(x, y: Int, z) = {
	  assert (size z > 0 and x + y > 0) -- liquid type
	  a = x + y -- val declaration, let binding
	  b = a :: z -- list cons
	  s = "x = $x, x + y = ${x + y}"
	  var i = 0 -- var declaration
	  while i < a {

		step = b.last match { -- pattern matching
		  1 | 2 => 1
		  name@3 => 2 -- name binding
		  name if name < 5 => 3
		  _ -> 4
		}


		lambda = { x => x + step }  // lambda definition

		newlist = {
			elem <- z  -- do-block
			pure elem.toString
		}

		i := lambda i // variable assignment
	  }
	}


Package System
==============

Packages are compressed serialized Lasca AST trees.
This allows target machine compilation/interpretation with whole program optimizations.
And it's cross-platform representations.

Packages are transferred via bittorrent or alike P2P service.
https://lasca.io would be kind of a torrent tracker site.

Memory Management
=================

Concurrent Mark and Sweep for main actor. (Boehm_ conservative gc for starter).
Consider https://wiki.haskell.org/GHC/Memory_Management

Per actor stack and heap. GC when actor is waiting. (See Erlang_, Pony_)

Concurrency
===========

Ideas
-----

- Actors or CPS.

- Async/await

- Future/Promise

I think Actors/Erlang is better choice for further distributed application.
See Erlang/OTP Scala/Akka for best practices.

Reactiveness
============

Fully asynchronous APIs.

Consider libuv, see Julia.

FFI (Foreign Functions Interface)
=================================

Must be as straightforward and simple as possible.
See `Pony FFI <https://tutorial.ponylang.org/c-ffi/calling-c.html>`_
or `Rust FFI <https://doc.rust-lang.org/book/ffi.html>`_.

Exception Handling
==================

Go style ``panic``/``recover`` ??
Don't see how it's different from try/catch/finally.

See:
* https://blog.golang.org/defer-panic-and-recover
* https://dave.cheney.net/2012/01/18/why-go-gets-exceptions-right
* http://stackoverflow.com/questions/3413389/panic-recover-in-go-v-s-try-catch-in-other-languages

Thoughts About OOP
==================
Pros:

OOP gives subtyping, inheritance, and dynamic dispatch.

Cons:

Subtyping implies all sorts of problems: least upper bound search for type inference,
variance complexities (variance annotations, covariant/contravariant positions),
conforming to Liskov Substitutions Principle.

I suggest getting benefits and avoiding problems by allowing subtyping only for operations, in form of Type Classes.
No data subtyping/inheritance. Consider Go-like embedding.

.. include:: LangsOverview.rst

.. _Liquid Haskell: https://github.com/ucsd-progsys/liquidhaskell
.. _LLVM: http://llvm.org/
.. _Haskell Defered type checking: https://ghc.haskell.org/trac/ghc/wiki/DeferErrorsToRuntime
.. _Akka: http://akka.io
.. _Erlang: https://www.erlang.org
.. _Boehm: https://www.hboehm.info/gc/
.. _Pony: https://www.ponylang.org
.. _Leon: https://github.com/epfl-lara/leon
.. [1] https://en.wikipedia.org/wiki/Persistent_data_structure
.. [2] https://www.infoq.com/presentations/Value-Identity-State-Rich-Hickey