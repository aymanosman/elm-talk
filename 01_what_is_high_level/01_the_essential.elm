import Html exposing (Html, text)
import Mouse

main : Signal Html
main =
  Signal.map (text << toString) Mouse.position

-- Mouse.position : Signal (Int, Int)
-- Html.text : String -> Html
-- Signal.map : (a -> b) -> Signal a -> Signal b

{-
 A 'signal' is a value that changes over time. Notice that
 what we end up with is a value of type `Signal Html` which
 represents a component that displays the mouse position
 for all points in time.

---
---

 type Signal α = Time → α

 'GUI' = Signal Html or 'Html over time'
 -}
