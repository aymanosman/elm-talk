import Html exposing (..)
import StartApp.Simple as StartApp

main =
  StartApp.start {model = init, view = view, update = update}

init = 1

view addr model =
  div [] []

update action model =
  model
