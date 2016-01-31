import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (..)
import Mouse
import Time

main : Signal Element
main = Signal.map2 view circlePos Mouse.position

view : (Float, Float) -> (Int, Int) -> Element
view (x, y) (mx, my) =
  collage 400 400
  [ circleAt x y
    -- uncomment below
    |> move (-200, 200)
    |> move (toFloat mx, toFloat -my)
  ]

angle : Signal Float
angle =
  Signal.foldp (\_ angle -> angle + 1/10) 0 (Time.fps 30)

circlePos : Signal (Float, Float)
circlePos =
  Signal.map (\angle -> fromPolar (50, angle)) angle

circleAt : Float -> Float -> Form
circleAt x y =
  circle 10
    |> filled red
    |> move (x, -y)
