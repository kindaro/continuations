{-# LANGUAGE Rank2Types #-}

module RecCont where

-- | I claim there is a functor T from a to T a.
data T a = T { unT :: forall r. (a -> r) -> r }

-- | This is the object operation of T.
t :: a -> T a
t x = T $ \f -> f x

-- | `run id` is the inverse of the object operation of T.
run :: (a -> b) -> T a -> b
run f (T x) = x f

-- | This is the morphism operation of T.
ft :: (a -> b) -> T a -> T b
ft f = \(T x) -> T $ \g -> x (g . f)

-- ^
-- λ run id (ft (+10) (t 10))
-- 20

-- | This is the inverse of the morphism operation of T.
runft :: (T a -> T b) -> a -> b
runft f x = run id $ f (t x)

-- | A Kleisli morphism into T.
rec :: Int -> T Int
rec x = t (x - 1)

-- | This is the binding operation in the monad on T.
bind :: (a -> T b) -> T a -> T b
bind f x = run f x

-- ^
-- λ run id $ bind rec . bind rec $ t 10
-- 8
--
-- λ run id $ foldl (.) id (replicate 10 $ bind rec) $ t 10
-- 0

-- | This is the cartesian product on T.
mf :: T a -> T b -> T (a, b)
mf x y = t (run id x, run id y)

-- ^
-- λ run id $ ft (uncurry (+)) $ mf (t 1) (t 2)
-- 3
