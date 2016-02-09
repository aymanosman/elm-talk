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
  , response : String
  }

type Action
  = Noop
  | MakeLol
  | FailedLol Http.Error
  | FailedParse String
  | NiceLol Foo

update : Action -> Model -> (Model, Effects Action)
update act model =
  case act of
    MakeLol ->
      (model, createFoo "lol" "wut")

    FailedLol httpError ->
      ({model | response = toString httpError }, Effects.none)

    FailedParse msg ->
      ({model | response = msg}, Effects.none)

    NiceLol foo ->
      ({model | response = toString foo }, Effects.none)

    Noop ->
      (model, Effects.none)


createFoo : String -> String -> Effects Action
createFoo login pass =
  let body =
        multipart [ stringData "login" login
                  , stringData "password" pass
                  ]
      dec =
        Json.oneOf [Json.map Ok' fooResponse, Json.map Err' Json.string]
        -- Json.maybe fooResponse
  in
  Http.post dec "/reverse" body
  |> Task.toResult
  |> Task.map handleFoo
  |> Effects.task


handleFoo : Result Http.Error ServerResponse -> Action
handleFoo resp =
  case resp of
    Err httpError->
      FailedLol httpError

    Ok resp ->
      case resp of
        Err' msg ->
          FailedParse "haha" -- msg

        Ok' foo ->
          NiceLol foo


type ServerResponse
  = Ok' Foo
  | Err' String

type alias Foo = { text : String }
fooResponse : Json.Decoder Foo
fooResponse =
  Json.object1 Foo ("text" := Json.string)


view : Signal.Address Action -> Model -> Html
view addr model =
  div []
      [ div [] [ text model.welcomeText ]
      , button [ onClick addr MakeLol ]
                 [ text "Click Me!" ]
      , input [ value model.foo ]
              []
      , div []
            [ text "Response: "
            , pre [] [ text model.response ]
            ]
      ]

init : (Model, Effects Action)
init =
  let model =
        { welcomeText = "Hello Snappy"
        , foo = ""
        , response = ""
        }
  in
  (model, Effects.none)



app : StartApp.App Model
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
