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
  | MakeForm
  | MakeBork
  | MakeJson
  | FailedLol Http.Error
  | FailedParse String
  | NiceLol Foo
  | Text String

init : (Model, Effects Action)
init =
  let model =
        { welcomeText = "Mascot"
        , foo = ""
        , response = ""
        }
  in
    (model, Effects.none)

update : Action -> Model -> (Model, Effects Action)
update act model =
  case act of
    MakeForm ->
      (model, postForm "/reverse" "text" model.foo)

    MakeBork ->
      (model, postForm "/reverse" "lol" "wut")

    MakeJson ->
      (model, postJson "/reverse-json" <|
         "{\"payloadText\": \"" ++ model.foo ++ "\"}")

    FailedLol httpError ->
      ({model | response = toString httpError }, Effects.none)

    FailedParse msg ->
      ({model | response = msg}, Effects.none)

    NiceLol foo ->
      ({model | response = toString foo }, Effects.none)

    Text t ->
      ({model | foo = t }, Effects.none)

    Noop ->
      (model, Effects.none)


postForm : String -> String -> String -> Effects Action
postForm url key val =
  let
      headers = [("Content-Type", "application/x-www-form-urlencoded")]
  in
    post' url headers <| Http.string (key ++ "=" ++ val)

post' url headers body =
  let
    dec =
      Json.oneOf [Json.map Ok' fooResponse, Json.map Err' errResponse]
    req =
      { verb = "POST"
      , headers = headers
      , url = "http://localhost:8080" ++ url
      , body = body
      }
  in
    Http.send Http.defaultSettings req -- dec "/reverse" body
      |> Http.fromJson dec
      |> Task.toResult
      |> Task.map handleFoo
      |> Effects.task


postJson : String -> String -> Effects Action
postJson url body =
  let headers = [("Content-Type", "application/json")]
  in
    post' url headers <| Http.string body

handleFoo : Result Http.Error ServerResponse -> Action
handleFoo resp =
  case resp of
    Err httpError->
      FailedLol httpError

    Ok resp ->
      case resp of
        Err' errR ->
          FailedParse errR.err

        Ok' foo ->
          NiceLol foo


type ServerResponse
  = Ok' Foo
  | Err' ErrR

type alias Foo = { payloadText : String }
fooResponse : Json.Decoder Foo
fooResponse =
  Json.object1 Foo ("payloadText" := Json.string)

type alias ErrR = { err : String }
errResponse : Json.Decoder ErrR
errResponse =
  Json.object1 ErrR ("err" := Json.string)


view : Signal.Address Action -> Model -> Html
view addr model =
  let div' btn = div [] [btn]
  in
  div []
      [ div [] [ text model.welcomeText ]
      , div' <| button [ onClick addr MakeBork ]
                       [ text "Borked!" ]
      , div' <| button [ onClick addr MakeForm ]
                       [ text "Make form-urlencoded request!" ]
      , div' <| button [ onClick addr MakeJson ]
                       [ text "Make json request!" ]
      , input [ value model.foo
              , on "input" targetValue (Signal.message addr << Text)
              ]
              []
      , div []
            [ text "Response: "
            , pre [] [ text model.response ]
            ]
      ]


-- Boilerplate

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
