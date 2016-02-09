{-# LANGUAGE OverloadedStrings #-}
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Control.Applicative
import           Data.ByteString                             (ByteString)
import qualified Data.ByteString.Char8                       as BS
import           Data.Monoid                                 ((<>))
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Auth.Backends.JsonFile
import           Snap.Snaplet.Heist
import           Snap.Snaplet.Session.Backends.CookieSession
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Application


------------------------------------------------------------------------------
-- | Handle new user form submit
handleNewUser :: Handler App (AuthManager App) ()
handleNewUser = method POST handleFormSubmit
  where
    handleFormSubmit =
      do registerUser "login" "password"
         writeBS "{\"lol\": 42}"


handleReverse :: Handler App App ()
handleReverse = method POST h
  where
    h =
      do mtxt <- getParam "text"
         case mtxt of
           Nothing -> writeBS "param `text` required"

           Just t ->
              writeBS ("{\"text\": "  <> BS.reverse t <>  "}")


------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [ -- ("/new_user", with auth handleNewUser)
           ("/reverse", handleReverse)
         , ("src-elm",   serveDirectory "src-elm")
         , ("",          serveDirectory "static")
         , ("/", render "base")
         ]


------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    s <- nestSnaplet "sess" sess $
           initCookieSessionManager "site_key.txt" "sess" (Just 3600)

    -- NOTE: We're using initJsonFileAuthManager here because it's easy and
    -- doesn't require any kind of database server to run.  In practice,
    -- you'll probably want to change this to a more robust auth backend.
    a <- nestSnaplet "auth" auth $
           initJsonFileAuthManager defAuthSettings sess "users.json"
    addRoutes routes
    addAuthSplices h auth
    return $ App h s a

