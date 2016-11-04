module Empire.API.Graph.AddSubgraph where

import           Data.Binary                   (Binary)
import           Prologue

import           Empire.API.Data.Connection    (Connection)
import           Empire.API.Data.GraphLocation (GraphLocation)
import           Empire.API.Data.Node          (Node, NodeId)
import qualified Empire.API.Response           as Response
import qualified Empire.API.Graph.Request      as G
import qualified Empire.API.Topic              as T
import qualified Empire.API.Request            as R

data Request = Request { _location    :: GraphLocation
                       , _nodes       :: [Node]
                       , _connections :: [Connection]
                       } deriving (Generic, Show, Eq)
type Result = [NodeId]

type Response = Response.Response Request Result
instance Response.ResponseResult Request Result

makeLenses ''Request

instance Binary Request

instance G.GraphRequest Request where location = location

topicPrefix = "empire.graph.node.addSubgraph"
instance T.MessageTopic (R.Request Request)  where topic _ = topicPrefix <> T.request
instance T.MessageTopic Response             where topic _ = topicPrefix <> T.response
