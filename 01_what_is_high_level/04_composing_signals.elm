import Html exposing (..)
import Mouse

main : Signal Html
main =
  Signal.map2 view Mouse.position numClicks

{-
  The important function here is `map2`. Its type isplay
  map2 : (a -> b -> c) -> Signal a -> Signal b -> Signal c

In other words, it combines two signals to produce a third
signal.
 -}

view : (Int, Int) -> Int -> Html
view mp clicks =
  div []
    [ div []
          [text <| "Mouse position: " ++ toString mp]
    , div []
          [text <| "Number of clicks: " ++ toString clicks]
    ]

numClicks : Signal Int
numClicks =
  Signal.foldp (\a b -> b + 1) 0 Mouse.clicks

