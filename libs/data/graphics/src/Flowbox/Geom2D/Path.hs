---------------------------------------------------------------------------
-- Copyright (C) Flowbox, Inc - All Rights Reserved
-- Unauthorized copying of this file, via any medium is strictly prohibited
-- Proprietary and confidential
-- Flowbox Team <contact@flowbox.io>, 2014
---------------------------------------------------------------------------
module Flowbox.Geom2D.Path where

import Flowbox.Geom2D.ControlPoint
import Flowbox.Prelude

data Path a = Path { controlPoints :: [ControlPoint a]
                   , isClosed        :: Bool
                   } deriving (Eq, Ord, Show)

instance Functor Path where
    fmap f (Path points closed) = Path ((fmap.fmap) f points) closed

--instance Applicative Path where
--    pure a = Path (pure a) False
--    {-# INLINE pure #-}
--    Path a <*> Path b = Path (a <*> b)
--    {-# INLINE (<*>) #-}
