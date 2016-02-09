module App where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

import Http exposing (multipart, stringData)
import Json.Decode as Json exposing ((:=))
import Task exposing (..)
import Effects exposing (Never, Effects)
import StartApp


type alias Model =
  { welcomeText : String
  , foo : String
  }

type Action
  = Noop
  | MakeLol
  | FailedLol Http.Error
  | NiceLol Foo

update : Action -> Model -> (Model, Effects Action)
update act model =
  case act of
    MakeLol ->
      (model, createNewUser "lol" "wut")
    FailedLol httpError ->
      ({model | foo = toString httpError }, Effects.none)
    NiceLol foo ->
      ({model | foo = toString foo }, Effects.none)
    Noop ->
      (model, Effects.none)


createNewUser : String -> String -> Effects Action
createNewUser login pass =
  let body =
        multipart [ stringData "login" login
                  , stringData "password" pass
                  ]
  in
  Http.post fooResponse "/new_user" body
  |> Task.toResult
  |> Task.map handleUserResponse
  |> Effects.task


handleUserResponse : Result Http.Error Foo -> Action
handleUserResponse resp =
  case resp of
    Err msg ->
      FailedLol msg

    Ok foo ->
      NiceLol foo


type alias Foo = { lol : Int }
fooResponse : Json.Decoder Foo
fooResponse =
  Json.object1 Foo ("lol" := Json.int)


view : Signal.Address Action -> Model -> Html
view addr model =
  div []
      [ button [ onClick addr MakeLol ]
               [ text "Click Me!" ]
      , input [ value model.foo ]
              []
      , text model.welcomeText
      ]

init : (Model, Effects Action)
init =
  let model =
        { welcomeText = "HHHello Snappy"
        , foo = ""
        }
  in
  (model, Effects.none)



app =
  StartApp.start { init = init
                 , view = view
                 , update = update
                 , inputs = []
                 }

main : Signal Html
main =
  app.html

port tasks : Signal (Task Never ())
port tasks =
  app.tasks
