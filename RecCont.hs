{-# LANGUAGE Rank2Types #-}


module RecCont where


-- | I claim there is an endofunctor T from Hask to a subcategory thereof that consists of
--   functions of a certain form:

data T a = T { unT :: forall r. (a -> r) -> r }


-- | This is the object operation of T.

t :: a -> T a
t x = T $ \f -> f x


-- | `run id` is the inverse of the object operation of T.

run :: (a -> b) -> T a -> b
run f (T x) = x f


-- | This is the morphism operation of T.
--
-- λ run id (ft (+10) (t 10))
-- 20

ft :: (a -> b) -> T a -> T b
ft f = \(T x) -> T $ \g -> x (g . f)


-- | This is the inverse of the morphism operation of T.

runft :: (T a -> T b) -> a -> b
runft f x = run id $ f (t x)


-- | This is the contravariant morphism of the functor on T.

contraft :: (a -> b) -> T b -> T a
contraft f = undefined  -- It is actually impossible to write. The initial value of a
                        -- continuation defined this way is fixed and inaccessible.


-- | A Kleisli morphism into T.

rec :: Int -> T Int
rec x = t (x - 1)


-- | This is the binding operation in the monad on T.
--
-- λ run id $ bind rec . bind rec $ t 10
-- 8
--
-- λ run id $ foldl (.) id (replicate 10 $ bind rec) $ t 10
-- 0

bind :: (a -> T b) -> T a -> T b
bind f x = run f x


-- | Another way of spelling bind. Is it distinct?
--
-- λ run id $ bind' rec . bind' rec $ t 10
-- 8
--
-- λ run id $ foldl (.) id (replicate 10 $ bind' rec) $ t 10
-- 0

bind' :: (a -> T b) -> T a -> T b
bind' f x = T $ \k -> run (run k) (ft f x)


-- | And yet another way of spelling bind. Is it distinct?
--
-- λ run id $ bind' rec . bind' rec $ t 10
-- 8
--
-- λ run id $ foldl (.) id (replicate 10 $ bind' rec) $ t 10
-- 0

bind3 :: (a -> T b) -> T a -> T b
bind3 f (T x) = T $ \k -> x (run k . f)


-- | This is the cartesian product on T.
--
-- λ run id $ ft (uncurry (+)) $ mf (t 1) (t 2)
-- 3
--
-- λ run print $ ft (uncurry ($)) $ mf (t (+2)) (t 3)
-- 5

mf :: T a -> T b -> T (a, b)
mf x y = t (run id x, run id y)
