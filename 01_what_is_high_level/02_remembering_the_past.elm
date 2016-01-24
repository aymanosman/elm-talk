import Html exposing (..)
import Html.Events exposing (onClick)

{-
 Maybe skip this discussion of foldp until after the StartApp module is
 introduced?
 -}

main : Signal Html
main =
  Signal.map (view buttonMailbox.address) numClicks

view : Signal.Address () -> Int -> Html
view addr clicks =
  div []
    [ button [onClick addr ()] [text "Click Me!"]
    , text (showClicks clicks)
    ]

buttonMailbox : Signal.Mailbox ()
buttonMailbox = Signal.mailbox ()

numClicks : Signal Int
numClicks =
  Signal.foldp (\a b -> b + 1) 0 buttonMailbox.signal

showClicks : Int -> String
showClicks n =
  case n of
    0 -> ""

    n ->
      "Number of times you clicked me: " ++ toString n

