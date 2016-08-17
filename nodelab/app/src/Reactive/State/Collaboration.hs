module Reactive.State.Collaboration where

import           Data.Aeson                     (ToJSON)
import           Data.DateTime                  (DateTime)
import           Data.Map.Lazy                  (Map)
import           Utils.PreludePlus

import           Empire.API.Graph.Collaboration (ClientId)
import           Empire.API.JSONInstances ()

newtype ColorId = ColorId { unColorId :: Int } deriving (Eq, Show, Generic)
numColors     = 8

data Client = Client { _lastSeen :: DateTime
                     , _colorId  :: ColorId
                     } deriving (Eq, Show, Generic)

data State = State { _knownClients :: Map ClientId Client
                   } deriving (Eq, Show, Generic)

makeLenses ''State
makeLenses ''Client

instance ToJSON State
instance ToJSON Client
instance ToJSON ColorId

instance Default State where
    def = State def