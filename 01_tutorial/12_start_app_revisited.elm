import Html exposing (..)
import Html.Events exposing (onClick)

{-

Let's implement StartApp.Simple.start using what we have
learnt so far.

-}

main : Signal Html
main =
  mystart
  { model = init
  , view = view
  , update = update
  }


type alias Model =
  { count : Int
  }

type Action
  = NoOp
  | Increment

init : Model
init = {count = 1}

view : Signal.Address Action -> Model -> Html
view addr model =
  div []
    [ text (toString model.count)
    , div []
          [button [onClick addr Increment]
                  [text "increment"]]
    ]


update : Action -> Model -> Model
update action model =
  case action of
    Increment ->
      { model |
        count = model.count + 1
      }
    NoOp -> model

type alias Config =
  { model : Model
  , view : Signal.Address Action -> Model -> Html
  , update : Action -> Model -> Model
  }

-- This really is ALL there is to the `start` function!
mystart : Config -> Signal Html
mystart config =
  let actions = Signal.mailbox NoOp
      models =
        Signal.foldp config.update config.model actions.signal
  in 
  Signal.map (view actions.address) models
