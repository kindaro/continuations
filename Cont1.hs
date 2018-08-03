{-# LANGUAGE Rank2Types #-}


module Cont1 where


-- | This is the monadic version of the functor T described in RecCont.

newtype T1 m a = T1 { unT1 :: forall r. (a -> m r) -> m r }


-- | This is the dot operation of T1.

t :: a -> T1 a
t x = T1 $ \f -> f x


-- | The only runner available to us in this module will be the runner to the terminal object.

run :: (a -> m ()) -> T1 a -> m ()
run f (T1 x) = x f


-- | This is the arrow operation of T.
--
-- λ run id (ft (+10) (t 10))
-- 20

ft :: (a -> b) -> T1 a -> T1 b
ft f = \(T1 x) -> T1 $ \g -> x (g . f)
