{-# LANGUAGE CPP                       #-}

module Luna.Compilation.Pass.Dirty.Handler where

import           Data.Prop
import           Development.Placeholders
import           Prologue                                        hiding (Getter, Setter, read)

import           Luna.Compilation.Pass.Dirty.Data.Env            (Env)
import qualified Luna.Compilation.Pass.Dirty.Data.Env            as Env
import qualified Luna.Compilation.Pass.Dirty.Data.Env            as Env
import           Luna.Compilation.Pass.Dirty.Data.Label          (Dirty (Dirty), DirtyVal (DirtyVal))
import qualified Luna.Compilation.Pass.Dirty.Data.Label          as Label
import qualified Luna.Compilation.Pass.Dirty.Dirty               as Dirty
import           Luna.Compilation.Pass.Dirty.Monad               (DirtyMonad)
import           Luna.Syntax.Builder
import qualified Luna.Syntax.Model.Graph                         as G
import           Luna.Syntax.Model.Graph.Builder.Class           (MonadBuilder)

import           Luna.Evaluation.Runtime                         (Dynamic, Static)

import           Luna.Syntax.AST.Term.Class                      (Lam)
import           Luna.Syntax.Model.Graph
import           Luna.Syntax.Model.Graph.Builder
import           Luna.Syntax.Model.Layer
import           Luna.Syntax.Model.Network.Builder.Node          (NodeInferable, TermNode)
import           Luna.Syntax.Model.Network.Builder.Node.Inferred
import           Luna.Syntax.Model.Network.Term


#define PassCtxDirty(m, ls, term) ( ls   ~ NetLayers a                           \
                                  , term ~ Draft Static                          \
                                  , ne   ~ Link (ls :< term)                     \
                                  , Castable e ne                                \
                                  , MonadIO m                                    \
                                  , MonadBuilder n e m                           \
                                  , NodeInferable m (ls :< term)                 \
                                  , TermNode Lam  m (ls :< term)                 \
                                  , HasProp Dirty (ls :< term)                   \
                                  , Prop Dirty    (ls :< term) ~ DirtyVal        \
                                  , DirtyMonad (Env (Ref (Node (ls :< term)))) m \
                                  )


nodesToExecute :: PassCtxDirty(m, ls, term) =>  m [Ref (Node (ls :< term))]
nodesToExecute = do
    mapM_ Dirty.followDirty =<< Env.getReqNodes
    Env.getReqNodes


reset :: DirtyMonad (Env node) m => m ()
reset = Env.clearReqNodes


connect :: PassCtxDirty(m, ls, term) => Ref (Node (ls :< term)) -> Ref (Node (ls :< term)) -> m ()
connect prev next = do
    isPrevDirty <- Dirty.isDirty <$> read prev
    Dirty.markSuccessors $ if isPrevDirty
        then prev
        else next


markModified :: PassCtxDirty(m, ls, term) => Ref (Node (ls :< term)) -> m ()
markModified = Dirty.markSuccessors
