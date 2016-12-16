module Empire.API.Data.PortRef where

import Prologue
import Data.Aeson           (FromJSON, ToJSON)
import Data.Binary          (Binary)
import Empire.API.Data.Port (OutPort, InPort, PortId(..))
import Empire.API.Data.Node (NodeId)

data InPortRef  = InPortRef  { _dstNodeId :: NodeId
                             , _dstPortId :: InPort
                             } deriving (Show, Eq, Generic, Ord)

data OutPortRef = OutPortRef { _srcNodeId :: NodeId
                             , _srcPortId :: OutPort
                             } deriving (Show, Eq, Generic, Ord)

data AnyPortRef = OutPortRef' OutPortRef | InPortRef' InPortRef deriving (Show, Eq, Generic)

instance Ord AnyPortRef where
  (InPortRef'  _)  `compare` (OutPortRef' _) = LT
  (OutPortRef' _)  `compare` (InPortRef'  _) = GT
  (InPortRef'  a)  `compare` (InPortRef'  b) = a `compare` b
  (OutPortRef' a)  `compare` (OutPortRef' b) = a `compare` b

nodeId' :: AnyPortRef -> NodeId
nodeId' (OutPortRef' (OutPortRef nid _)) = nid
nodeId' (InPortRef'  (InPortRef  nid _)) = nid

nodeId :: Getter AnyPortRef NodeId
nodeId = to nodeId'

portId' :: AnyPortRef -> PortId
portId' (OutPortRef' (OutPortRef _ pid)) = OutPortId pid
portId' (InPortRef'  (InPortRef  _ pid)) = InPortId  pid

portId :: Getter AnyPortRef PortId
portId = to portId'

toAnyPortRef :: NodeId -> PortId -> AnyPortRef
toAnyPortRef nid (InPortId pid)  = InPortRef'  $ InPortRef  nid pid
toAnyPortRef nid (OutPortId pid) = OutPortRef' $ OutPortRef nid pid

makeLenses ''AnyPortRef
makeLenses ''OutPortRef
makeLenses ''InPortRef

instance Binary AnyPortRef
instance Binary InPortRef
instance Binary OutPortRef

instance ToJSON AnyPortRef
instance FromJSON AnyPortRef
instance ToJSON OutPortRef
instance FromJSON OutPortRef
instance ToJSON InPortRef
instance FromJSON InPortRef
