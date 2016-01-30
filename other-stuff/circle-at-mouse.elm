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
  [ circleAt x y
  ]
  |> List.map (adjust w)
  |> collage w w


circleAt : Int -> Int -> Form
circleAt x y =
  circle 10
    |> filled red
    |> move (toFloat x, toFloat -y)


adjust : Float -> Form -> Form
adjust width =
  move (-width/2, width/2)
