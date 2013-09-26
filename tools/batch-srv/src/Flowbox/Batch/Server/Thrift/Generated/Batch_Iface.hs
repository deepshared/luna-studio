{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-missing-fields #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-# OPTIONS_GHC -fno-warn-name-shadowing #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-----------------------------------------------------------------
-- Autogenerated by Thrift Compiler (0.9.0)                      --
--                                                             --
-- DO NOT EDIT UNLESS YOU ARE SURE YOU KNOW WHAT YOU ARE DOING --
-----------------------------------------------------------------

module Batch_Iface where
import Prelude ( Bool(..), Enum, Double, String, Maybe(..),
                 Eq, Show, Ord,
                 return, length, IO, fromIntegral, fromEnum, toEnum,
                 (.), (&&), (||), (==), (++), ($), (-) )

import           Control.Exception      
import           Data.ByteString.Lazy   
import           Data.Hashable          
import           Data.Int               
import           Data.Text.Lazy         ( Text )
import qualified Data.Text.Lazy       as TL
import           Data.Typeable          ( Typeable )
import qualified Data.HashMap.Strict  as Map
import qualified Data.HashSet         as Set
import qualified Data.Vector          as Vector

import           Thrift                 
import           Thrift.Types           ()

import qualified Fs_Types               
import qualified Graphview_Types        
import qualified Projects_Types         
import qualified Attrs_Types            
import qualified Defs_Types             
import qualified Graph_Types            
import qualified Libs_Types             
import qualified Types_Types            


import           Batch_Types            

class Batch_Iface a where
  projects :: a -> IO (Vector.Vector Projects_Types.Project)
  projectByID :: a -> Maybe Int32 -> IO Projects_Types.Project
  createProject :: a -> Maybe Projects_Types.Project -> IO Projects_Types.Project
  openProject :: a -> Maybe Text -> IO Projects_Types.Project
  updateProject :: a -> Maybe Projects_Types.Project -> IO ()
  closeProject :: a -> Maybe Int32 -> IO ()
  storeProject :: a -> Maybe Int32 -> IO ()
  libraries :: a -> Maybe Int32 -> IO (Vector.Vector Libs_Types.Library)
  libraryByID :: a -> Maybe Int32 -> Maybe Int32 -> IO Libs_Types.Library
  createLibrary :: a -> Maybe Libs_Types.Library -> Maybe Int32 -> IO Libs_Types.Library
  loadLibrary :: a -> Maybe Text -> Maybe Int32 -> IO Libs_Types.Library
  unloadLibrary :: a -> Maybe Int32 -> Maybe Int32 -> IO ()
  storeLibrary :: a -> Maybe Int32 -> Maybe Int32 -> IO ()
  buildLibrary :: a -> Maybe Int32 -> Maybe Int32 -> IO ()
  runLibrary :: a -> Maybe Int32 -> Maybe Int32 -> IO Text
  libraryRootDef :: a -> Maybe Int32 -> Maybe Int32 -> IO Defs_Types.Definition
  defsGraph :: a -> Maybe Int32 -> Maybe Int32 -> IO Defs_Types.DefsGraph
  defByID :: a -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO Defs_Types.Definition
  addDefinition :: a -> Maybe Defs_Types.Definition -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO Defs_Types.Definition
  updateDefinition :: a -> Maybe Defs_Types.Definition -> Maybe Int32 -> Maybe Int32 -> IO ()
  removeDefinition :: a -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO ()
  definitionChildren :: a -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO (Vector.Vector Defs_Types.Definition)
  definitionParent :: a -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO Defs_Types.Definition
  resolveDefinition :: a -> Maybe Text -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO (Vector.Vector Defs_Types.DefPtr)
  newTypeModule :: a -> Maybe Text -> Maybe (Vector.Vector Types_Types.Type) -> IO Types_Types.Type
  newTypeClass :: a -> Maybe Text -> Maybe (Vector.Vector Text) -> Maybe (Vector.Vector Types_Types.Type) -> IO Types_Types.Type
  newTypeFunction :: a -> Maybe Text -> Maybe Types_Types.Type -> Maybe Types_Types.Type -> IO Types_Types.Type
  newTypeUdefined :: a -> IO Types_Types.Type
  newTypeNamed :: a -> Maybe Text -> Maybe Types_Types.Type -> IO Types_Types.Type
  newTypeName :: a -> Maybe Text -> IO Types_Types.Type
  newTypeTuple :: a -> Maybe (Vector.Vector Types_Types.Type) -> IO Types_Types.Type
  nodesGraph :: a -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO Graphview_Types.GraphView
  nodeByID :: a -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO Graph_Types.Node
  addNode :: a -> Maybe Graph_Types.Node -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO Graph_Types.Node
  updateNode :: a -> Maybe Graph_Types.Node -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO ()
  removeNode :: a -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO ()
  connect :: a -> Maybe Int32 -> Maybe (Vector.Vector Int32) -> Maybe Int32 -> Maybe (Vector.Vector Int32) -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO ()
  disconnect :: a -> Maybe Int32 -> Maybe (Vector.Vector Int32) -> Maybe Int32 -> Maybe (Vector.Vector Int32) -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO ()
  nodeDefaults :: a -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO (Map.HashMap (Vector.Vector Int32) Graph_Types.DefaultValue)
  setNodeDefault :: a -> Maybe (Vector.Vector Int32) -> Maybe Graph_Types.DefaultValue -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO ()
  removeNodeDefault :: a -> Maybe (Vector.Vector Int32) -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> Maybe Int32 -> IO ()
  fS_ls :: a -> Maybe Text -> IO (Vector.Vector Fs_Types.FSItem)
  fS_stat :: a -> Maybe Text -> IO Fs_Types.FSItem
  fS_mkdir :: a -> Maybe Text -> IO ()
  fS_touch :: a -> Maybe Text -> IO ()
  fS_rm :: a -> Maybe Text -> IO ()
  fS_cp :: a -> Maybe Text -> Maybe Text -> IO ()
  fS_mv :: a -> Maybe Text -> Maybe Text -> IO ()
  ping :: a -> IO ()
  dump :: a -> IO ()
  shutdown :: a -> IO ()
