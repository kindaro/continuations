_Explorations of continuation passing in Haskell and JavaScript._

Introduction.
=============

My goal here is to explore continuation passing, insomuch as is to my ability, from the categorial
perspective, and on the vessels of Haskell and JavaScript.

The first observation I want to pinpoint is that, in JavaScript, continuations never return. My
consideration is to assign *undefined* as terminal object, denote it as 1, and say that JS
continuations have type `(i -> r) -> 1`. Since in JS all functions are effectful, I may elaborate
to `(i -> m r) -> m 1`. This is now a readily acceptable type signature for Haskell. The
implication is that the runner for such objects may only have type `(a -> m 1) -> m 1` --- with
return type fixed. A trivial function parameter for such runner might be: `console.log` in JS,
`print` in Haskell.

The observation companion to the first is that, in Haskell, instances of Functor, Applicative and
Monad for continuations (in [transformers][1]) are phrased in terms of the runner. Should that
mean that we cannot have them with the restricted runner of JS?

The point to note here is that the runner is simply the accessor of the only field of a newtype
and thus may be replaced by a pattern match or even coerced. So it appears that, for fairness, we
cannot use these devices either. Continuations should be abstract for us.

Plan of attack.
===============

* `RecCont.js` shows some difficulties one may meet when trying to accomplish recursive
  composition of asynchronous functions in JS.

* `RecCont.hs` defines type T of continuations and shows how the difficulties met in JS are
  trivial to overcome if only the access to the underlying function is granted, or the return
  value can be gotten ahold of any other way.

* To further explore the complications one may meet in JS, `Cont1` defines a type T1 similar to
  continuations, but without the benefit of returning any meaningful value, which is aligned with
  the behaviour of asynchronous functions in JS.


[1]: https://hackage.haskell.org/package/transformers-0.5.5.0/docs/src/Control.Monad.Trans.Cont.html#ContT
