import Task
import Html exposing (..)

main =
  Signal.map (text << toString) values


values : Signal {currentTime : String}
values =
  foo
