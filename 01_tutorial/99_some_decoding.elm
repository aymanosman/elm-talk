module Main (..) where

import Html exposing (..)
import Json.Decode as D


main =
    let
        view v = div [] [ text (toString v) ]
    in
        div
            []
            (List.map view all)


all =
    [ val1, val2, val3 ]


val1 =
    D.decodeString (D.list D.int) "1,2,3"


val2 =
    D.decodeString (D.list D.int) "[1,2,3,a,5]"


val3 =
    D.decodeString (D.list D.int) "[1,2,3,4,5]"
