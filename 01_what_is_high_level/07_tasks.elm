import Task exposing (..)
import Http
import Html exposing (..)

main : Signal Html
main =
  Signal.map (text << toString) values

{-

Tasks -- performing side effects

As a side effect of being a 'pure' language, Elm will feel
somewhat ceremonious when it comes to performing IO.

-}

values : Signal String
values =
  result.signal

result : Signal.Mailbox String
result =
  Signal.mailbox "loading..."

-- This is weird and will require some explanation
port runasdasdj : Task Http.Error ()
port runasdasdj =
  getDate `andThen` (sendToAddress result.address)

getDate : Task Http.Error String
getDate =
  Http.getString "http://www.timeapi.org/utc/now"

sendToAddress : Signal.Address a -> a -> Task c ()
sendToAddress addr x =
  Signal.send addr (Debug.log "got something" x)

