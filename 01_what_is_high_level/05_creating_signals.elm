import Html exposing (Html, text, div)
import Html.Attributes exposing (class, style, id)
import Html.Events exposing (onClick)

{-

  Mailboxes -- creating signals out of user actions

Basically shows how you translate event handlers to the Elm paradigm

-}

main : Signal Html
main =
  Signal.map2 view fsize blueOrGreen

view : Int -> String -> Html
view fsize colour =
  let foo = [ ("color", colour)
            , ("font-size", toString fsize ++ "px")
            ]
  in
    div []
        [ div [ style foo
              , class "some-class"
              , id "some-id"
              , onClick clicky.address ()
              ]
              [ text "lolwut" ]
        ]

-- () is pronounced 'unit'. Take it to mean 'nothing'
clicky : Signal.Mailbox ()
clicky = Signal.mailbox ()

blueOrGreen : Signal String
blueOrGreen =
  let toggleColour _ col = if col == "red" then "green" else "red"
  in
  Signal.foldp toggleColour "red" clicky.signal

fsize : Signal Int
fsize =
  Signal.foldp (\_ acc -> acc + 10) 20 clicky.signal



{-

http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Signal#Mailbox

type alias Mailbox =
  { address : Signal.Address a
  , signal : Signal.Signal a
  }

-}
