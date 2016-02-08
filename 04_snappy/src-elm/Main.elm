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


-- port ff : Task Http.Error String
-- port ff =
--   let resp =
--         Task.map (Debug.log "lol") <| createNewUser "foo" "bar"
--   in
--     Task.onError resp (Task.succeed << Debug.log "err" << toString)

port ff : Task a String
port ff =
  let resp =
        Task.map (Debug.log "lol") <| createNewUser "foo" "bar"
  in
    Task.toResult resp |> Task.map (Debug.log "err" << toString)
