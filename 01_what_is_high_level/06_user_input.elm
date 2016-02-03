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
      {-
      This will be really familiar to anyone who has used React.js but will
      probably look odd to anyone else. We are saying, When the user inputs
      some text, send a message to the mailbox of `Text "new text"`, then we
      explicitly hook that text back into the input (the model.text). Why such
      indirection? Answer, unidirectional data flow.

      MVC does not scale https://facebook.github.io/flux/docs/overview.html

      Try to comment out the `on "input" ...` attribute.
      -}
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
