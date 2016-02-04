import Html exposing (Html, text, div)
import Html.Attributes exposing (class, style, id)
import Html.Events exposing (onClick)

{-

  Mailboxes -- creating signals out of user actions

Basically shows how you translate event handlers to the Elm paradigm

-}

main : Signal Html
main =
  Signal.map view blueOrGreen

view : String -> Html
view c =
  let foo = [("color", c)]
  in
    div []
        [ div [ style foo
              , class "some-class"
              , id "some-id"
              , onClick clicky.address ()
              ]
              [ text "lolwut" ]
        ]

blueOrGreen : Signal String
blueOrGreen =
  let toggleColour _ col = if col == "red" then "green" else "red"
  in
  Signal.foldp toggleColour "red" clicky.signal

-- () is pronounced 'unit'. Take it to mean 'nothing'
clicky : Signal.Mailbox ()
clicky = Signal.mailbox ()



{-

http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Signal#Mailbox

type alias Mailbox =
  { address : Signal.Address a
  , signal : Signal.Signal a
  }

-}
