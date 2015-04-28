---------------------------------------------------------------------------
-- Copyright (C) Flowbox, Inc - All Rights Reserved
-- Unauthorized copying of this file, via any medium is strictly prohibited
-- Proprietary and confidential
-- Flowbox Team <contact@flowbox.io>, 2015
---------------------------------------------------------------------------
module Luna.Data.ImportInfo where

import           Control.Monad.RWS        (RWST)
import qualified Control.Monad.RWS        as RWST
import qualified Data.Map                 as Map
import           Data.Map                 (Map)
import qualified Flowbox.Data.MapForest   as MapForest
import           Luna.Data.StructInfo     (StructInfo, OriginInfo(OriginInfo), Scope)
import qualified Luna.Data.StructInfo     as SI
import           Luna.Syntax.Decl         (Path)
import           Luna.Syntax.Name.Path    (NamePath, QualPath(QualPath))
import qualified Luna.Syntax.Name.Path    as NP
import           Luna.Data.ModuleInfo     (ImportError, qualPathToPath)
import           Flowbox.Prelude

type ID = Int

data Tag = Vars | Types deriving (Show, Eq)


data Import = Import {
    _impPath  :: QualPath,
    _wildcard :: Bool,
    _hiding   :: [NamePath],
    _targets  :: [NamePath],
    _rename   :: Maybe NamePath
} deriving (Generic, Show, Eq, Read)


data ImportInfo = ImportInfo {
    _path        :: QualPath,       -- move to Namespace (?)
    _imports     :: [Import],
    _structInfos :: Map QualPath StructInfo,
    _symTable    :: Map NamePath [OriginInfo],
    _typeTable   :: Map NamePath [OriginInfo],
    _errors      :: [ImportError]
} deriving (Generic, Show, Eq, Read)

makeLenses ''ImportInfo

----------------------------------------------------------------------------------------
-- Type classes
----------------------------------------------------------------------------------------
class ImportInfoMonad m where
    get :: m ImportInfo
    put :: ImportInfo -> m ()



----------------------------------------------------------------------------------------
-- Utils
----------------------------------------------------------------------------------------
setPath :: QualPath -> ImportInfo -> ImportInfo
setPath p = path .~ p



getPath :: ImportInfo -> Path
getPath info = qualPathToPath $ _path info


getImportPaths :: ImportInfo -> [QualPath]
getImportPaths info = map _impPath (_imports info)

-- Creates the mapping between symbol names (NamePath) and their origins (OriginInfo)
createSymTable :: ImportInfo -> ImportInfo
createSymTable = addMNameToSymTable . addMNameToTypeTable . createSymTableVars . createSymTableTypes

-- TODO[PMo] add every module name to both type- and symTable
addMNameToSymTable :: ImportInfo -> ImportInfo
addMNameToSymTable info = info & (symTable %~ (Map.unionWith (++) (createNameMap $ _imports info)))

addMNameToTypeTable :: ImportInfo -> ImportInfo
addMNameToTypeTable info = info & (typeTable %~ (Map.unionWith (++) (createNameMap $ _imports info)))

createNameMap :: [Import] -> Map NamePath [OriginInfo]
createNameMap imps = Map.fromList tuples
    where tuples = fmap (\imp -> (moduleObjectName (_impPath imp), [OriginInfo (_impPath imp) 0])) imps -- TODO check if it's really 0


createSymTableVars :: ImportInfo -> ImportInfo
createSymTableVars info = info & (symTable .~ (combineScopes Vars info))

createSymTableTypes :: ImportInfo -> ImportInfo
createSymTableTypes info = info & (typeTable .~ (combineScopes Types info))



regError :: ImportError -> ImportInfo -> ImportInfo
regError err = errors %~ (err:)



-- combines the top-level scopes of all the imported modules
-- results in a map from NamePath to [OriginInfo] -- if a given
-- symbol appears in more than one module, the list isn't a singleton
combineScopes :: Tag -> ImportInfo -> Map NamePath [OriginInfo]
combineScopes tag info = Map.unionsWith (++) maps
    where strInfos = Map.elems $ _structInfos info
          maps     = map (topLevelScope tag) strInfos



topLevelScope :: Tag -> StructInfo -> Map NamePath [OriginInfo]
topLevelScope tag sInfo = Map.fromList nps
    where scope = SI.scopeLookup (0::Int) sInfo
          vars  = MapForest.toList $ (case tag of Vars -> fst; Types -> snd) scope
          nps   = map (\(p, origin) -> (toNamePath p, [origin])) vars



moduleObjectName :: QualPath -> NamePath
moduleObjectName (QualPath _ name) = NP.single name


toNamePath :: [Text] -> NamePath
toNamePath (t:ts) = NP.multi t ts          


qualPathToList :: QualPath -> [Text]
qualPathToList qp = (NP._name qp) : (NP._path qp)

-----------------------------------------------------------------------------------------
--Instances
-----------------------------------------------------------------------------------------

instance Monoid ImportInfo where
    mempty      = ImportInfo mempty mempty mempty mempty mempty mempty
    mappend a b = ImportInfo (mappend (a ^. path)        (b ^. path))
                             (mappend (a ^. imports)     (b ^. imports))
                             (mappend (a ^. structInfos) (b ^. structInfos))
                             (mappend (a ^. symTable)    (b ^. symTable))
                             (mappend (a ^. typeTable)   (b ^. typeTable))
                             (mappend (a ^. errors)      (b ^. errors))


instance (Monad m, Monoid w) => ImportInfoMonad (RWST r w ImportInfo m) where
    get = RWST.get
    put = RWST.put
                             
