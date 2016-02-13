import Graphics.Element exposing (..)
import Markdown
import Html exposing (..)
-- import Html.Attributes exposing (style)
import Mouse

main =
  Signal.map view Mouse.position

view mp =
  flow down
  [ c1
  , Html.toElement 300 100 (d1 mp)
  , c1
  ]


c1 = Markdown.toElement """
# Hello
  1. two
"""

d1 mp =
  div []
      [ text <| "Mouse position: " ++ toString mp]
