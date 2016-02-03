import Html exposing (..)
import Html.Attributes exposing (value, autofocus)
import Html.Events exposing (on, targetValue)
import String
import StartApp.Simple as StartApp

type alias Model =
  { text : String
  }

type Action
  = Text String

init : Model
init =
  { text = ""
  }

update : Action -> Model -> Model
update act model =
  case act of
    Text t ->
      Model t


view : Signal.Address Action -> Model -> Html
view addr model =
  div []
      [ input [ value model.text
              , autofocus True
              , on "input" targetValue
                  (Signal.message addr << Text)
              ]
              []
      , input [ value (String.reverse model.text)]
              []
      ]


main : Signal Html
main =
  StartApp.start
          { model = init
          , view = view
          , update = update}
