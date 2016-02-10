{-# LANGUAGE OverloadedStrings #-}
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Data.ByteString                             (ByteString)
import qualified Data.ByteString.Char8                       as BS
import           Data.Monoid                                 ((<>))
import           Data.Aeson
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Snaplet.Session.Backends.CookieSession
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Application
import Control.Monad.Trans (liftIO)


------------------------------------------------------------------------------
handleReverse :: Handler App App ()
handleReverse =
  method POST
  $ do mtxt <- getPostParam "text"
       lols <- getPostParams
       liftIO $ print lols
       case mtxt of
         Nothing ->
           do liftIO $ putStrLn "EEE"
              writeBS "{\"err\": \"param `text` required\"}"

         Just t ->
           writeBS ("{\"text\": \"" <> BS.reverse t <> "\"}")

data Rev = Rev { _revText :: String }

instance ToJSON Rev where
  toJSON (Rev text) = object ["text" .= text]


handleReverseJson :: Handler App App ()
handleReverseJson =
  method POST
  $ do lol <- getPostParam "todo get json" -- getJSON
       writeJson $ toJSON (Rev "yay")


writeJson :: (MonadSnap m, ToJSON a) => a -> m ()
writeJson val =
  do modifyResponse $ setHeader "Content-Type" "application/json'"
     writeLBS $ encode val


------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [ ("/reverse", handleReverse)
         , ("/reverse-json'", handleReverseJson)
         , ("src-elm", serveDirectory "src-elm")
         , ("", serveDirectory "static")
         , ("/", render "base")
         ]


------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    s <- nestSnaplet "sess" sess $
           initCookieSessionManager "site_key.txt" "sess" (Just 3600)
    addRoutes routes
    return $ App h s

