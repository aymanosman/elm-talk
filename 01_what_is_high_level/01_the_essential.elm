import Html exposing (Html)
import Mouse

main : Signal Html
main =
  Signal.map (Html.text << toString) Mouse.position

-- Mouse.position : Signal (Int, Int)
-- Html.text : String -> Html
-- Signal.map : (a -> b) -> Signal a -> Signal b

{-
 A 'signal' is a value that changes over time.


 Conceptually a signal has the following type:
 type Signal α = Time → α

 The radical idea is to model our user interface as a
 *value* that changes over time!

 UI = Signal Html or 'Html over time'

 -}
