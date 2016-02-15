module App where

import Html exposing (..)
import Mouse

main : Signal Html
main =
  let view s = text ("From JS: " ++ s)
  in
  Signal.map view toElmPort

{-

Ports are Elm's major way of interoprating with arbitrary
JavaScript and third-party libraries.

They act as gatekeepers of data flowing in and out of your
Elm application and the rest of the JavaScript environment.

-}

-- You declare data flowing from JS -> Elm by a port that
-- has no accompanying binding
port toElmPort : Signal String

-- Conversley, you declare data flowing from Elm -> JS by a
-- port followed by a binding
port toJSPort : Signal (Int, Int)
port toJSPort =
  Mouse.position

-- notice how similar this looks to an ordinary definition

-- Try replacing the above Mouse.position with another signal

mySig : Signal (Int, Int)
mySig =
  let multOf5 (x, y) =
        x % 5 == 0 && y % 5 == 0
  in
  Signal.filter multOf5 (0, 0) Mouse.position
