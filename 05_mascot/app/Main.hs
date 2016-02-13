{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import Network.Wai.Middleware.RequestLogger
import Network.Wai.Middleware.Static

main :: IO ()
main =
  scotty 8080 site

site :: ScottyM ()
site =
  do middleware logStdoutDev
     middleware $ staticPolicy (addBase "static")
     matchAny "/" $ text "Success"
     matchAny "/reverse-json" $ text "Success"
