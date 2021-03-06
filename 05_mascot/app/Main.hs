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
     middleware $ staticPolicy $ addBase "static"

     get "/" $ file "static/index.html"

     let handleRev =
           do t <- param "text" -- 'raises' if param not found, caught by 'rescue'
              json $ object ["payloadText" .= toJSON (reverse (t :: String))
                            , "foo" .= "lol"
                            ]
              `rescue`
              (\msg ->
                json $ object ["err" .= toJSON msg])

     get "/reverse" handleRev

     post "/reverse" handleRev

      -- hack to satisfy browser
     options "/reverse-json" $ text "beam me up!"

     post "/reverse-json"
       $ do mpayload <- jsonData -- decode <$> body
            case mpayload of
              Nothing ->
                json $ object ["err" .= "could not decode payload"]
              Just (Payload t) ->
                json . toJSON . Payload $ reverse t


data Payload = Payload
  { payloadText :: String
  } deriving (Show, Generic, ToJSON, FromJSON)

