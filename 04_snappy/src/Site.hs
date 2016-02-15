{-# LANGUAGE OverloadedStrings #-}
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as BS
import           Data.Monoid ((<>))
import           Data.Aeson
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Session.Backends.CookieSession
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Application
import Control.Monad.Trans (liftIO)
import Control.Applicative (empty)
import Text.Printf (printf)


------------------------------------------------------------------------------

handleReverse :: Handler App App ()
handleReverse =
  method POST
  $ do mtxt <- getPostParam "text"
       lols <- getPostParams
       liftIO $ printf "POST params: %s\n" (show lols)
       case mtxt of
         Nothing ->
           writeBS "{\"err\": \"param `text` required\"}"

         Just t ->
           writeBS ("{\"text\": \"" <> BS.reverse t <> "\"}")


data Payload = Payload { payloadText :: String }

-- Example of manually marshalling data, see mascot for auto derived version
instance ToJSON Payload where
  toJSON (Payload text) =
    object ["text" .= text]

instance FromJSON Payload where
  parseJSON (Object v) =
    Payload <$> v.:"text"
  parseJSON _ = empty


handleReverseJson :: Handler App App ()
handleReverseJson =
  method POST
  $ do b <- readRequestBody 1000 -- read no more than 1000 bytes
       liftIO $ printf "PPP %s\n" (show b)
       case eitherDecode b of
         Left err ->
           writeJson $ object ["err" .= err]

         Right (Payload t) ->
           writeJson $ toJSON (Payload (reverse t))


writeJson :: (MonadSnap m, ToJSON a) => a -> m ()
writeJson val =
  do modifyResponse $ setHeader "Content-Type" "application/json"
     writeLBS $ encode val


------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [ ("/reverse", handleReverse)
         , ("/reverse-json", handleReverseJson)
         , ("", serveDirectory "static")
         ]


------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing initApp

initApp :: Initializer App App App
initApp =
  do s <- nestSnaplet "sess" sess $
       initCookieSessionManager "site_key.txt" "sess" (Just 3600)
     addRoutes routes
     return $ App s

