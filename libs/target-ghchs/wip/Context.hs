{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}

{-# LANGUAGE OverlappingInstances #-}
{-# LANGUAGE IncoherentInstances #-}

import Control.Applicative
import Control.Monad.IO.Class
import Control.Monad.Trans
import Control.Monad.State

data Pure a = Pure { fromPure :: a } deriving (Show)

instance Monad Pure where
    return = Pure
    (Pure a) >>= f = f a

instance Functor Pure where
    fmap f (Pure a) = Pure (f a)

instance Applicative Pure where
    pure = Pure
    (Pure f) <*> (Pure a) = Pure $ f a

------------------------------------------------------------------------------------------

newtype a :> m = InContext (m a)

liftCtx                 = InContext
unliftCtx (InContext a) = a




class Pipe a b c where
    pipe :: a -> b -> c

(>>>) = pipe


instance out~b => Pipe (a->b) a out where
    pipe f a = f a

instance (Monad m, out~(m b)) => Pipe (a->b) (m a) out where
    pipe f ma = do
        a <- ma
        return $ f a


instance (Monad m, out~b) => Pipe (m a->b) a out where
    pipe f a = f (return a)


instance (out~b, a1~a2) => Pipe (a1->b) a2 out where
    pipe f a = f a


instance (Monad m, out~(m b)) => Pipe (m (a->b)) a out where
    pipe (mf) a = do
        f <- mf
        return $ f a

instance (Monad m1, Monad m2, m1~m2, out~(m2 b)) => Pipe (m1 (a->b)) (m2 a) out where
    pipe (mf) ma =  do
        f <- mf
        a <- ma
        return $ f a

instance (Monad m, a~b, out~(c :> m)) => Pipe (b->c) (a :> m) out where
    pipe f (InContext ma) = InContext $ do
        a <- ma
        return $ f a

instance (Monad m, a~b, out~(c :> m)) => Pipe ((b->c) :> m) a out where
    pipe (InContext mf) a = InContext $ do
        f <- mf
        return $ f a

instance (Monad m, a~b, out~(c :> m)) => Pipe ((b->c) :> m) (a :> m) out where
    pipe (InContext mf) (InContext ma) = InContext $ do
        f <- mf
        a <- ma
        return $ f a



instance (Monad m, a~b, out~(c :> m)) => Pipe (b -> (c :> m)) (a :> m) out where
    pipe f (InContext ma) = InContext $ do
        a <- ma
        unliftCtx $ f a


instance (Monad m, Monad (mt m), MonadTrans mt, a~b, out~(c :> mt m)) => 
         Pipe (b -> (c :> m)) (a :> mt m) out where
    pipe f (InContext ma) = InContext $ do
        a <- ma
        lift . unliftCtx $ f a

--------------


instance (a~b, out~(c :> IO)) => Pipe (b -> (c :> IO)) (a :> Pure) out where
    pipe f (InContext (Pure a)) = InContext $ do
        unliftCtx $ f a





test :: () :> IO
test = do
    liftCtx $ print "hello"

pureVal :: String :> Pure
pureVal = InContext $ return "test"

ctxPrint :: String -> () :> IO
ctxPrint s = do
    liftCtx $ print s


strInIO :: String :> IO
strInIO = liftCtx $ return "test"


testStateIO :: String :> StateT Float IO
testStateIO = InContext $ do
    --lift $ print "!"
    x <- get
    put (x+1)
    return "ala"



testStatePure :: String :> StateT Float Pure
testStatePure = InContext $ do
    x <- get
    put (x+1)
    return "ala"


--testStateIO2 :: String :> (IO :>> StateT Float)
--testStateIO2 = undefined


--newtype (a :: * -> *) :>> (m :: (* -> *) -> * -> *) = InContext2 (m a)

t2 :: () -> Int
t2 _ = 5

sme :: [Int] -> [Int] -> [Int]
sme = (++) 

main = do
    print $ sme >>> [(1::Int)] >>> (2::Int)

    print =<< (unliftCtx $ t2 >>> test)

    print =<< (unliftCtx $ ctxPrint >>> strInIO)

    --print =<< runStateT (unliftCtx $ ctxPrint >>> testStatePure) 5
    --let x = runStateT (unliftCtx $ ctxPrint >>> testStatePure) 5
    let x = (unliftCtx $ ctxPrint >>> pureVal)
        --x :: Int

    putStrLn "---"

    x

    print "end"