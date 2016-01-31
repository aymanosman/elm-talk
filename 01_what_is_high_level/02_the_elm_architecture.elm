import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp

{-
  In the 'elm architecture', all apps break down into the same
  three components. Model, view and update.
 -}

main : Signal Html
main =
  StartApp.start
            { model = init
            , view = view
            , update = update
            }


type alias Model = Int

type Action
  = Increment

init : Model
init = 1

view : Signal.Address Action -> Model -> Html
view addr model =
  div []
    [ text (toString model)
    , div []
          [button [onClick addr Increment]
                  [text "increment"]]
    ]


update : Action -> Model -> Model
update action model =
  case action of
    Increment ->
      model + 1

{-

Problems:
1) Try to add a Decrement button

-}
