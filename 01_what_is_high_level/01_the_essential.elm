import Html exposing (text)
import Mouse

main =
  Signal.map view Mouse.position

view coords =
  text (toString coords)
