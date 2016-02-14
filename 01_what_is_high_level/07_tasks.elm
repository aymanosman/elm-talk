import Task exposing (..)
import Http
import Html exposing (..)

main : Signal Html
main =
  Signal.map (text << toString) values

{-

Tasks -- performing side effects

-}

values : Signal String
values =
  result.signal

result : Signal.Mailbox String
result =
  Signal.mailbox ""

port run : Task Http.Error ()
port run =
  getDate `andThen` (sendToAddress result.address)

getDate : Task Http.Error String
getDate =
  Http.getString "http://www.timeapi.org/utc/now"

sendToAddress : Signal.Address a -> a -> Task c ()
sendToAddress addr x =
  Signal.send addr (Debug.log "got something" x)

