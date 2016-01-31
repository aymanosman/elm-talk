import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (..)
import Time

main : Signal Element
main = Signal.map view circlePos

view : (Float, Float) -> Element
view (x, y) =
  collage 400 400
  [ circleAt x y
  -- , show (x, y) |> toForm
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
