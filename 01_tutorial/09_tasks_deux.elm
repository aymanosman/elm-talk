import Task exposing (..)
import Http
import Time
import Html exposing (..)

main : Signal Html
main =
  Signal.map text date.signal

{-

We deal wih signals not side effects in the rest of Elm, so
how to bridge this world of side effects and signals?

We need to create a signal out of the results of running
these side effects. And there is only one way to create
brand new signals in Elm. Mailboxes.

What we need is a way to send the result of running a task
to a mailbox, for that we have the following function:

Signal.send : Signal.Address a -> a -> Task.Task x ()

-}

date : Signal.Mailbox String
date =
  Signal.mailbox "loading..."

port getDate : Task Http.Error ()
port getDate =
  Http.getString "http://www.timeapi.org/utc/now"
  `andThen` (Signal.send date.address)

-- port foobar : Signal (Task Http.Error ())
-- port foobar =
--   Signal.map (\_ -> getDate) (Time.every Time.second)
