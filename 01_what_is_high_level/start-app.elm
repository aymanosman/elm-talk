module StartApp.Simple where

import Debug
import Html exposing (Html)
import Signal exposing (Address)

type alias Config model action =
    { model : model
    , view : Address action -> model -> Html
    , update : action -> model -> model
    }

start : Config model action -> Signal Html
start config =
  let
    actions =
      Signal.mailbox Nothing

    address =
      Signal.forwardTo actions.address Just

    update maybeAction model =
      case maybeAction of
        Just action ->
            config.update action model

        Nothing ->
            Debug.crash "This should never happen."

    model =
      Signal.foldp update config.model actions.signal
  in
    Signal.map (config.view address) model
