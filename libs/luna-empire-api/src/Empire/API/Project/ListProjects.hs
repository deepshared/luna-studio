{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances  #-}
module Empire.API.Project.ListProjects where

import           Data.Aeson              (ToJSON)
import           Data.Binary             (Binary)
import           Data.UUID.Aeson         ()
import           Prologue

import           Empire.API.Data.Project (Project, ProjectId)
import qualified Empire.API.Request      as R
import qualified Empire.API.Response     as Response
import qualified Empire.API.Topic        as T

data Request = Request deriving (Generic, Show, Eq)

data Result  = Result { _projects :: [(ProjectId, Project)]
                      } deriving (Generic, Show, Eq)

data Update  = Update { _projects' :: [(ProjectId, Project)]
                      } deriving (Generic, Show, Eq)

type Response = Response.Response Request Result
instance Response.ResponseResult Request Result

makeLenses ''Request
makeLenses ''Result
makeLenses ''Update

instance Binary Request
instance Binary Result
instance Binary Update

instance ToJSON Request
instance ToJSON Result
instance ToJSON Update

topicPrefix = "empire.project.list"
instance T.MessageTopic (R.Request Request) where topic _ = topicPrefix <> T.request
instance T.MessageTopic Response            where topic _ = topicPrefix <> T.response
instance T.MessageTopic Update              where topic _ = topicPrefix <> T.update
