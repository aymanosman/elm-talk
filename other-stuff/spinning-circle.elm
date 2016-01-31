import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (..)
import Time

main : Signal Element
main = Signal.map view circlePos

view : (Float, Float) -> Element
view (len, angle) =
  let (x, y) = fromPolar (len, angle)
  in
  collage 400 400
  [ circleAt x y
  -- , show (x, y) |> toForm
  ]

circlePos : Signal (Float, Float)
circlePos =
  let f _ (r, angle) =
        if angle < 360
        then (r, angle + 1/10)
        else start
      start = (r, 0)
      r = 50 --radius
  in
    Signal.foldp f start (Time.fps 30)

circleAt : Float -> Float -> Form
circleAt x y =
  circle 10
    |> filled red
    |> move (x, -y)
