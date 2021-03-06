import Task exposing (..)
import Http
import Json.Decode as Json exposing ((:=))
import Html exposing (..)

main : Signal Html
main =
  Signal.map (text << toString) reverser.signal

{-

Sometimes we want to handle data that is not in the form of
a String. Elm here, like in other places, is strict about
what data it allows into the app. Incoming values must be
explicitly decoded into Elm values.

-}

reverser : Signal.Mailbox String
reverser =
  Signal.mailbox "loading..."

port getReverse : Task Http.Error ()
port getReverse =
  Http.get dec "http://localhost:8080/reverse?text=hello+elm"
  `andThen` (Signal.send reverser.address)

-- Here we are saying we are expecting to receive JSON
-- encoded data with the following shape:
-- {"payloadText": ..., "otherKey": ...}
-- Here we grab the data we want and throw the rest away.
dec : Json.Decoder String
dec =
  ("payloadText" := Json.string)


-- type alias Payload =
--   { payloadText : String
--   }

