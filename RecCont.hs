{-# LANGUAGE Rank2Types #-}

module RecCont where

data T a = T { unT :: forall r. (a -> r) -> r }

run :: (a -> b) -> T a -> b
run f (T x) = x f

t :: a -> T a
t x = T $ \f -> f x

ft :: (a -> b) -> T a -> T b
ft f = \(T x) -> T $ \g -> x (g . f)

-- ^
-- λ run id (ft (+10) (t 10))
-- 20

rec :: Int -> T Int
rec x = t (x - 1)

bind :: (a -> T b) -> T a -> T b
bind f x = run f x

-- ^
-- λ run id $ bind rec . bind rec $ t 10
-- 8
