---------------------------------------------------------------------------
-- Copyright (C) Flowbox, Inc - All Rights Reserved
-- Unauthorized copying of this file, via any medium is strictly prohibited
-- Proprietary and confidential
-- Flowbox Team <contact@flowbox.io>, 2014
---------------------------------------------------------------------------

{-# LANGUAGE ConstraintKinds           #-}
{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE MultiParamTypeClasses     #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE Rank2Types                #-}

module Flowbox.System.Log.Logger (
    module Flowbox.System.Log.Logger,
    module X,
    Priority(..)
) where

import           Control.Monad.State
import           Control.Monad.Writer
import           Data.DList                  (DList)
import qualified Data.DList                  as DList
import qualified Data.Maybe                  as Maybe
import qualified Data.String.Utils           as StringUtils
import           Flowbox.System.Log.Priority
import           Prelude                     hiding (fail, log)
import qualified System.Console.ANSI         as ANSI
import           System.IO                   (stderr)
import qualified System.Log.Logger           as HSLogger
--import           System.Log.Logger           hiding (getLogger, setLevel, Logger)

import           Control.Applicative
import           Flowbox.Source.Location     as X (moduleName)
import           Flowbox.System.Log.LogEntry (LogEntry (LogEntry))
import qualified Flowbox.System.Log.LogEntry as LogEntry



type LogList     = DList LogEntry
type LogWriter m = MonadWriter LogList m

type LogAction b = LogWriter m => String -> String -> m b
type Logger      = forall t t1. (t1 -> String -> t) -> t1 -> t
type LoggerIO    = MonadIO m => forall t. (t -> String -> Writer LogList ()) -> t -> m ()


getLogger :: String -> Logger
getLogger name action msg = action msg name


getLoggerIO :: String -> LoggerIO
getLoggerIO name action msg = runLogger $ action msg name


runLogger :: MonadIO m => Writer LogList a -> m a
runLogger m = do
    let (out, entries) = runWriter m
    mapM_ logIO $ DList.toList entries
    return out


log :: LogWriter m => Priority -> String -> String -> m()
log pri msg name = tell $ DList.singleton (LogEntry name pri msg)


append :: MonadWriter w m => w -> m ()
append = tell


logsIO :: LogList -> IO ()
logsIO entries = mapM_ logIO $ DList.toList entries


logIO :: MonadIO m => LogEntry.LogEntry -> m ()
logIO entry = liftIO $ do
    let name  = LogEntry.name     entry
        msg   = LogEntry.msg      entry
        pri   = LogEntry.priority entry
        sgr   = case pri of
                   TRACE       -> [ANSI.SetColor ANSI.Foreground ANSI.Vivid ANSI.Cyan   ]
                   DEBUG       -> [ANSI.SetColor ANSI.Foreground ANSI.Vivid ANSI.Magenta]
                   INFO        -> [ANSI.SetColor ANSI.Foreground ANSI.Vivid ANSI.Green  ]
                   WARNING     -> [ANSI.SetColor ANSI.Foreground ANSI.Vivid ANSI.Yellow ]
                   ERROR       -> [ANSI.SetColor ANSI.Foreground ANSI.Vivid ANSI.Red    ]
                   CRITICAL    -> [ANSI.SetColor ANSI.Foreground ANSI.Vivid ANSI.Red    ]

        -- TODO [PM] : find better solution than copying private functions from library
        componentsOfName :: String -> [String] -- [PM] copied from System.Log.Logger
        componentsOfName n =
          let joinComp [] _ = []
              joinComp (x:xs) [] = x : joinComp xs x
              joinComp (x:xs) accum =
                  let newlevel = accum ++ "." ++ x in
                      newlevel : joinComp xs newlevel
              in
              HSLogger.rootLoggerName : joinComp (StringUtils.split "." n) []

        --parentLoggers :: String -> IO [Logger] -- [PM] copied from System.Log.Logger
        parentLoggers [] = return []
        parentLoggers n =
            let pname = (head . drop 1 . reverse . componentsOfName) n
                in
                do parent <- HSLogger.getLogger pname
                   next <- parentLoggers pname
                   return (parent : next)

        getLoggerPriority :: String -> IO HSLogger.Priority -- [PM] copied from System.Log.Logger
        getLoggerPriority n =
            do l <- HSLogger.getLogger n
               pl <- parentLoggers n
               case Maybe.mapMaybe HSLogger.getLevel (l : pl) of
                 [] -> return HSLogger.DEBUG
                 (x:_) -> return x

    lpri <- hspri2pri <$> getLoggerPriority name

    when (pri >= lpri) $ ANSI.hSetSGR stderr sgr

    HSLogger.logM name (pri2hspri pri) msg

    when (pri >= lpri) $ ANSI.hSetSGR stderr []


trace :: LogAction ()
trace = log TRACE


debug :: LogAction ()
debug = log DEBUG


info :: LogAction ()
info = log INFO


warning :: LogAction ()
warning = log WARNING


error :: LogAction ()
error = log ERROR


critical :: LogAction ()
critical = log CRITICAL


criticalFail :: LogAction b
criticalFail msg name = do
    log CRITICAL msg name
    fail msg


setLevel :: MonadIO m => Priority -> String -> m ()
setLevel lvl name = liftIO $ HSLogger.updateGlobalLogger name (HSLogger.setLevel $ pri2hspri lvl)


setIntLevel :: Int -> String -> IO ()
setIntLevel lvl = setLevel nlvl where
    nlvl = case lvl of
        0 -> CRITICAL
        1 -> ERROR
        2 -> WARNING
        3 -> INFO
        4 -> DEBUG
        5 -> TRACE
        _ -> TRACE