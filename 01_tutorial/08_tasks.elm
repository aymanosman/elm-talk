import Task exposing (..)
import Http
import Time
import Html exposing (..)

main : Html
main =
  text "Nothing to see here"


port getDate : Task Http.Error String
port getDate =
  Http.getString "http://www.timeapi.org/utc/now"
    |> Task.map logToConsole

logToConsole : a -> a
logToConsole s =
  Debug.log "Got it " s

{-

Tasks -- performing side effects

As a side effect of being a 'pure' language, Elm will feel
somewhat ceremonious when it comes to performing IO.

This is probably the most seemingly 'unreasonable' part of
Elm's API.

There are two things that I would like you to understand
from this example.

1) A `Task a b` is a *description* of a side effect to
perform. It is like a post-it note with instructions
scribbled on it. Nothing has 'happened' yet.

2) You communicate your intention for this task to run to
the Elm runtime system by annotating the definition of the
task with the 'port' keyword.

This shows that ports are not
only used for interop but for 'running tasks'.

-}

-- foobar : Signal (Task Http.Error String)
-- foobar =
--   Signal.map (\_ -> getDate) (Time.every Time.second)
