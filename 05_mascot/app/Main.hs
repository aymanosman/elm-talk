{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}
module Main where

import Web.Scotty
import Network.Wai.Middleware.RequestLogger
import Network.Wai.Middleware.Static
import Data.Aeson (ToJSON, FromJSON, toJSON, object)
import GHC.Generics

(.=) = (,)

main :: IO ()
main =
  scotty 8080 site

site :: ScottyM ()
site =
  do middleware logStdoutDev
     middleware $ staticPolicy (addBase "static")

     get "/" $ file "static/index.html"

     post "/reverse"
       $ do t <- param "text"
            json $ toJSON $ Payload $ reverse t
            `rescue`
            (\msg ->
              json $ object ["err" .= toJSON msg])

     post "/reverse-json"
       $ do mpayload <- jsonData -- decode <$> body
            case mpayload of
              Nothing ->
                json $ object ["err" .= "could not decode payload"]
              Just p ->
                json $ toJSON $ Payload $ reverse (payloadText p)


data Payload = Payload
  { payloadText :: String
  } deriving (Show, Generic, ToJSON, FromJSON)

