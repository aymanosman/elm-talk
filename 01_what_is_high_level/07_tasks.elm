import Task exposing (..)
import Http
import Html exposing (..)

main =
  Signal.map (text << toString) values

{-

Tasks -- performing side effects

-}

base = "https://httpbin.org/"

values : Signal (Maybe Foo)
values =
  tasks.signal

tasks : Signal.Mailbox (Maybe Foo)
tasks =
  Signal.mailbox Nothing

type Foo
  = NoOp
  | F String

port run : Signal (Task a Foo)
port run =
  Http.send a b c

