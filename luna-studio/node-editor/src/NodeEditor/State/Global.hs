{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module NodeEditor.State.Global where

import           Common.Action.Command                    (Command)
import           Common.Debug                             (HasRequestTimes,
                                                           requestTimes)
import           Common.Prelude
import           Data.HashMap.Lazy                        (HashMap)
import           Data.Map                                 (Map)
import           Data.Set                                 (Set)
import           Data.Time.Clock                          (UTCTime)
import           Data.UUID.Types                          (UUID)
import           Data.Word                                (Word8)
import           LunaStudio.API.Graph.CollaborationUpdate (ClientId)
import           LunaStudio.Data.NodeLoc                  (NodeLoc)
import           LunaStudio.Data.NodeSearcher             (NodeSearcherData)
import           LunaStudio.Data.TypeRep                  (TypeRep)
import           NodeEditor.Event.Event                   (Event)
import qualified NodeEditor.React.Model.App               as App
import           NodeEditor.React.Model.NodeEditor        (NodeEditor)
import           NodeEditor.React.Model.Visualization     (Visualizer,
                                                           VisualizerId,
                                                           VisualizerMatcher,
                                                           VisualizerPath)
import           NodeEditor.State.Action                  (ActionRep, Connect,
                                                           SomeAction)
import qualified NodeEditor.State.Collaboration           as Collaboration
import qualified NodeEditor.State.UI                      as UI
import           System.Random                            (StdGen)
import qualified System.Random                            as Random


-- TODO: Reconsider our design. @wdanilo says that we shouldn't use MonadState at all
data State = State
        { _ui                  :: UI.State
        , _backend             :: BackendState
        , _actions             :: ActionState
        , _collaboration       :: Collaboration.State
        , _debug               :: DebugState
        , _selectionHistory    :: [Set NodeLoc]
        , _nodeSearcherData    :: NodeSearcherData
        , _waitingForTc        :: Bool
        , _preferedVisualizers :: HashMap TypeRep Visualizer
        , _visualizers         :: Map VisualizerId VisualizerMatcher
        , _internalVisualizers :: Map VisualizerId VisualizerPath
        , _random              :: StdGen
        }

data ActionState = ActionState
        { _currentActions       :: Map ActionRep (SomeAction (Command State))
        -- TODO[LJK]: This is duplicate. Find way to remove it but make it possible to get Connect without importing its instance
        , _currentConnectAction :: Maybe Connect
        } deriving (Generic)

instance Default ActionState

data BackendState = BackendState
        { _pendingRequests :: Map UUID UTCTime
        , _clientId        :: ClientId
        }

data DebugState = DebugState
        { _lastEvent :: Maybe Event
        , _eventNum  :: Int
        } deriving (Generic)

instance Default DebugState

makeLenses ''ActionState
makeLenses ''BackendState
makeLenses ''State
makeLenses ''DebugState

mkState :: ClientId -> StdGen -> State
mkState clientId' = State
    {- ui                   -} def
    {- backend              -} (BackendState def clientId')
    {- actions              -} def
    {- collaboration        -} def
    {- debug                -} def
    {- selectionHistory     -} def
    {- nodeSearcherData     -} def
    {- waitingForTc         -} False
    {- preferedVisualizers  -} mempty
    {- visualizers          -} mempty
    {- internalVisualizers  -} mempty


nextRandom :: Command State Word8
nextRandom = uses random Random.random >>= \(val, rnd) -> random .= rnd >> return val

getNodeEditor :: State -> NodeEditor
getNodeEditor = view (ui . UI.app . App.nodeEditor)

instance HasRequestTimes State where
    requestTimes = backend . pendingRequests
