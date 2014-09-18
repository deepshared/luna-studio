module Luna.Typechecker.ContextReduction (
    reduce, inHnf, toHnf
  ) where

import           Luna.Typechecker.AST.Type         (Type(..))

import           Luna.Typechecker.Typeclasses      (Pred(..),ClassEnv(..),byInst,entail)




inHnf :: Pred -> Bool
inHnf (IsIn _ t) = hnf t
  where hnf (TVar   _ ) = True
        hnf (TCon   _ ) = False  -- TODO [kgdk] 18 sie 2014: well, why actually can't this be true?
        hnf (TAp t1 _ ) = hnf t1
        hnf (TGen   _ ) = error "ContextReduction.hs:inHnf got TGen!" -- TODO [kgdk] 21 sie 2014: czy może tylko False?



toHnfs :: Monad m => ClassEnv -> [Pred] -> m [Pred]
toHnfs ce ps = do pss <- mapM (toHnf ce) ps
                  return (concat pss)
-- TODO [kgdk] 18 sie 2014: sprawdzić, czy to poniżej działa jako zamiennik
-- toHnfs ce ps = liftM concat $ mapM (toHnf ce)

-- TODO [kg]: doprowadzić do pojawienia się błędu "context reduction", zbadać przypadek
toHnf :: Monad m => ClassEnv -> Pred -> m [Pred]
toHnf ce p | inHnf p = return [p]
           | otherwise = case byInst ce p of
                           Nothing -> fail "context reduction"
                           Just ps -> toHnfs ce ps

simplify :: ClassEnv -> [Pred] -> [Pred]
simplify ce = loop []
  where loop rs []                              = rs
        loop rs (p:ps) | entail ce (rs ++ ps) p = loop rs ps
                       | otherwise              = loop (p:rs) ps
-- TODO [kgdk] 18 sie 2014: sprawdzić, czy to poniżej działa jako zamiennik
-- simplify ce = foldl eliminate []
--  where eliminate rs (p:ps) | entail ce (rs ++ ps) p = rs
--                            | otherwise              = (p:rs)

reduce :: Monad m => ClassEnv -> [Pred] -> m [Pred]
reduce ce ps = do qs <- toHnfs ce ps
                  return (simplify ce qs)
-- TODO [kgdk] 18 sie 2014: sprawdzić, czy to poniżej działa jako zamiennik
--reduce ce = liftM (simplify ce) $ toHnfs ce
-- TODO [kgdk] 18 sie 2014: w 'reduce' mamy zagwarantowane, że wszystko jest w HNF, więc
-- można by skorzystać z następującego (okrojonego) entail
--scEntail        :: ClassEnv -> [Pred] -> Pred -> Bool
--scEntail ce ps p = any (p `elem`) (map (bySuper ce) ps)
