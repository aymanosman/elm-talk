{-# LANGUAGE TemplateHaskell #-}

------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Application where

------------------------------------------------------------------------------
import Control.Lens
import Snap.Snaplet
import Snap.Snaplet.Session

------------------------------------------------------------------------------
data App = App
    { _sess :: Snaplet SessionManager
    }

makeLenses ''App

------------------------------------------------------------------------------
type AppHandler = Handler App App


