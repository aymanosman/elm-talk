import Html exposing (..)
import Mouse

main : Signal Html
main =
  Signal.map view numClicks

numClicks : Signal Int
numClicks =
  -- This is our focus. Given a signal of mouse clicks, we
  -- produce a new signal of the number of times the mouse
  -- was clicked so far.
  Signal.foldp (\_ b -> b + 1) 0 Mouse.clicks

{-

foldp will take some explanation...

First off the type of Mouse.clicks is `Signal ()`, which
is pronounced signal of unit. Unit signifies that there
is no data associated with the click event.

our goal, representing the number of clicks so far
numClicks : Signal Int

Mouse.clicks : Signal ()
foldp : (a -> s -> s) -> s -> Signal a -> Signal s
Specializing foldp to the types we know we want and have
foldp' : (() -> Int -> Int) -> Int -> Signal () -> Signal Int


-}

view : Int -> Html
view clicks =
  text ("Number of clicks: " ++ toString clicks)
