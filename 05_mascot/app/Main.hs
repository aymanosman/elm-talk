{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import Network.Wai.Middleware.RequestLogger
import Network.Wai.Middleware.Static
-- import Data.Aeson

main :: IO ()
main =
  scotty 8080 site

site :: ScottyM ()
site =
  do middleware logStdoutDev
     middleware $ staticPolicy (addBase "static")
     get "/" $ file "static/index.html"
     post "/reverse-json"
       $ do p <- param "foo"
            -- json $ object
            text p
