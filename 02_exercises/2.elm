import Html exposing (Html, text)
import Mouse
import Keyboard

{-

I've said that the UI is a *value* of type Signal Html.

Given a UI that displays the current mouse position and a
UI that displays the current state of the spacebar,
construct a UI that displays one or the other.

-}

main : Signal Html
main =
  mouseHtmlOrspaceHtml

mouseHtmlOrspaceHtml : Signal Html
mouseHtmlOrspaceHtml =
  Debug.crash "TODO"

mouseHtml : Signal Html
mouseHtml =
  Signal.map (text << toString) Mouse.position

spaceHtml : Signal Html
spaceHtml =
  Signal.map (toString >> text) Keyboard.space
