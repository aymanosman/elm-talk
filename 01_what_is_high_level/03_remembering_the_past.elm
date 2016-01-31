import Html exposing (..)
import Mouse

numClicks : Signal Int
numClicks =
  Signal.foldp (\a b -> b + 1) 0 Mouse.clicks

view : Int -> Html
view clicks =
  text <| "Number of clicks: " ++ toString clicks

main : Signal Html
main =
  Signal.map view numClicks
