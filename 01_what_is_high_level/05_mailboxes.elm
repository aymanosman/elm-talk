import Html exposing (Html, text, div)
import Html.Attributes exposing (class, style, id)
import Html.Events exposing (onClick)

{-

  Mailboxes -- creating signals out of user actions

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
  Signal.foldp (\_ color ->
                  if color == "red" then "green" else "red")
          "red"
            clicky.signal

clicky : Signal.Mailbox ()
clicky = Signal.mailbox ()