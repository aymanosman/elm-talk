import Task exposing (..)
import Http
import Date
import Html exposing (..)

main : Signal Html
main =
  Signal.map (text << toString) values

{-

Tasks -- performing side effects

-}

values : Signal (Maybe Date.Date)
values =
  result.signal

result : Signal.Mailbox (Maybe Date.Date)
result =
  Signal.mailbox Nothing

port run : Task Http.Error ()
port run =
  foo `andThen` (sendToAddress result.address)

foo =
  Http.getString "http://www.timeapi.org/utc/now"
    |> Task.map Date.fromString

sendToAddress addr mdate =
  case mdate of
    Err _ ->
      Signal.send addr Nothing

    Ok d ->
      Signal.send addr (Just d)

