module App where

import Html exposing (..)
import Http exposing (multipart, stringData)
import Json.Decode as Json exposing ((:=))
import Task exposing (..)
import Effects exposing (Never)
import StartApp

type alias Model = String

type Action
  = Noop

update act model =
  (model, Effects.none)

createNewUser : String -> String -> Task Http.Error Foo
createNewUser login pass =
  let body =
        multipart [ stringData "login" login
                  , stringData "password" pass
                  ]
  in
  Http.post fooResponse "/new_user" body


type alias Foo = { lol : Int }
fooResponse : Json.Decoder Foo
fooResponse =
  Json.object1 Foo ("lol" := Json.int)

-- port ff : Task Http.Error String
-- port ff =
--   let resp =
--         Task.map (Debug.log "lol") <| createNewUser "foo" "bar"
--   in
--     Task.onError resp (Task.succeed << Debug.log "err" << toString)

port ff : Task a String
port ff =
  let resp =
        createNewUser "foo" "bar"
  in
    Task.toResult resp |> Task.map (Debug.log "PPP" << toString)

view : Signal.Address Action -> Model -> Html
view addr model =
  text model


app =
  StartApp.start { init = ("HHHello Snappy", Effects.none)
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
