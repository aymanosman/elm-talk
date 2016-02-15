import Html exposing (Html)
import Mouse

-- main is the entrypoint of every Elm program
main : Signal Html
main =
  Signal.map (Html.text << toString) Mouse.position

{-
Let's step through the types

Mouse.position           : Signal (Int, Int)
toString                 : a -> String
toString'                : (Int, Int) -> String
Html.text                : String -> Html
(Html.text << toString') : (Int, Int) -> Html
Signal.map               : (a -> b) -> Signal a -> Signal b

Signal.map' : ((Int, Int) -> Html)
           -> Signal (Int, Int)
           -> Signal Html

-}

{-

A 'signal' is a value that changes over time.

Conceptually a signal has the following type:
type Signal α = Time → α

The radical idea is to model our user interface as a
*value* that changes over time!

UI = Signal Html or 'Html over time'

 -}
