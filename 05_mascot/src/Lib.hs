{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( site
    ) where

import Web.Scotty
import Network.Wai.Middleware.Cors

site :: ScottyM ()
site =
  do middleware simpleCors
     matchAny "/" $ text "Success"
