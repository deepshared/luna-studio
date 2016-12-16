module Empire.API.Graph.NodeSearcherUpdate where

import           Prologue
import           Data.Aeson                    (ToJSON)
import           Data.Binary                   (Binary)

import           Empire.API.Data.GraphLocation (GraphLocation)
import           Empire.API.Data.NodeSearcher  (Items)
import qualified Empire.API.Topic              as T

data Update = Update { _location         :: GraphLocation
                     , _nodeSearcherData :: Items
                     } deriving (Generic, Show, Eq)

makeLenses ''Update

instance Binary Update

instance ToJSON Update

topicPrefix = "empire.graph.nodeSearcher"
instance T.MessageTopic Update   where topic _ = topicPrefix <> T.update
