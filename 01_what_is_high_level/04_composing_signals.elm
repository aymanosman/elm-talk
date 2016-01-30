import Html exposing (..)
import Html.Events exposing (onClick)
import Mouse

main : Signal Html
main =
  Signal.map2 (view buttonMailbox.address)
              Mouse.position numClicks

view : Signal.Address () -> (Int, Int) -> Int -> Html
view addr coords clicks =
  div []
    [ div []
          [text <| "Mouse position: " ++ toString coords]
    , div []
          [ button [onClick addr ()]
                   [text "Click Me!"]
          , text (showClicks clicks)
          ]
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

