import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (..)
import Mouse

main : Signal Element
main = Signal.map view Mouse.position

view : (Int, Int) -> Element
view (x, y) =
  let w = 400
  in
  collage w w
  [ circle 10
    |> filled red
    |> move (-w/2, w/2)
    |> move (toFloat x, toFloat -y)
  ]
