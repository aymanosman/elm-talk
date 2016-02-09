module App where

import Html exposing (..)
import Http exposing (multipart, stringData)
import Json.Decode as Json exposing ((:=))
import Task exposing (..)

main : Html
main = text "Hello Snappy"

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
