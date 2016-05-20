module JS.UUID where

import Utils.PreludePlus

import           GHCJS.Types                    (JSString)
import qualified Data.UUID.Types as UUID
import qualified Data.JSString                  as JSString

foreign import javascript safe "generateUUID()" generateUUID' :: IO JSString

generateUUID :: IO UUID.UUID
generateUUID = generateUUID' >>= return . fromJust . UUID.fromString . JSString.unpack