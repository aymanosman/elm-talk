module App where

import Html exposing (..)

main : Signal Html
main =
  Signal.map text portValues

port portValues : Signal String

