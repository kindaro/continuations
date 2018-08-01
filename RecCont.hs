{-# LANGUAGE Rank2Types #-}

module RecCont where

data T a = T { run :: forall r. (a -> r) -> r }

t :: a -> T a
t x = T $ \f -> f x

ft :: (a -> b) -> T a -> T b
ft f = \(T x) -> T $ \g -> x (g . f)

-- ^
-- λ run (ft (+10) (t 10)) id
-- 20
