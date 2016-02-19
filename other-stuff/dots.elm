import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (..)
import Mouse

main : Signal Element
main =
  -- Signal.map draw dots
  Signal.map show mySig

-- draw : List (Int, Int) -> Element
draw ps =
  collage 1000 1000
   <| List.map (uncurry circleAt) ps

ff = Signal.map (Debug.log "ff") dots

dots =
  Signal.foldp (::) [] mySig

circleAt : Int -> Int -> Form
circleAt x y =
  circle 3
    |> filled red
    |> move (toFloat x, toFloat -y)

mySig : Signal (Int, Int)
mySig =
  let multOf5 (x, y) =
        x % 5 == 0 && y % 5 == 0
  in
  Signal.filter multOf5 (0, 0) Mouse.position
