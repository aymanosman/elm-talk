module App where

import Html exposing (..)
import Http exposing (multipart, stringData)
import Json.Decode as Json exposing ((:=))
import Task exposing (..)

main : Html
main = text "Hello Snappy"

createNewUser : String -> String -> Task Http.Error String
createNewUser login pass =
  let body =
        multipart [ stringData "login" login
                  , stringData "password" pass
                  ]
  in
  Http.post Json.string "/new_user" body


port ff : Task Http.Error String
port ff = createNewUser "foo" "bar"

