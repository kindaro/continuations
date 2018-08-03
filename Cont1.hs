{-# LANGUAGE Rank2Types #-}


module Cont1 where


-- | This is the monadic version of the functor T described in RecCont.

newtype T1 m a = T1 { unT1 :: forall r. (a -> m r) -> m r }


-- | This is the dot operation of T1.
--
-- λ :type t 2
-- t 2 :: Num a => T1 m a
--
-- λ run print $ t 2
-- 2

t :: a -> T1 m a
t x = T1 $ \f -> f x


-- | This is the abstract constructor of T1.
--
-- λ :type t1 (\k -> k 2)
-- t1 (\k -> k 2) :: Num a => T1 m a
--
-- λ run print $ t1 (\k -> k 2)
-- 2

t1 :: (forall b. (a -> m b) -> m b) -> T1 m a
t1 = T1


-- | The only runner available to us in this module will be the runner to the terminal object.

run :: (a -> m ()) -> T1 m a -> m ()
run f (T1 x) = x f
