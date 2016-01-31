import Html exposing (Html, text, div)
import Mouse

{-
 Try to stack things.

 Display the mouse position twice!

 Should look like this
 (193, 125)
 (193, 125)

 -}

main : Signal Html
main =
  Signal.map view Mouse.position

view : a -> Html
view mp =
  let foo = "this is how you bind variables"
      bar = text foo
  in
    -- Html tags are modelled as functions of two
    -- arguments, for example:
    -- div : List Attribute -> List Html -> Html.
    -- We will ignore Attributes for now.
    -- We know how to get Html from a String with `text`.
    div []
        [ div [] [bar]
        , text "something else"
        ]