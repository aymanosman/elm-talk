module App where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Json.Decode as Json
import StartApp.Simple as StartApp
import Array exposing (Array)


main : Signal Html
main =
  StartApp.start
            { model = init
            , view = view
            , update = withDebug << withLast <| update
            }

-- Model

type alias Model =
  { query : String
  , choices : Array Candidate
  , highlighted : Int
  , selected : Maybe Candidate
  , lastAction : Action
  }

type alias Candidate = String

type Action
  = NoOp
  | Query String
  | ClickSelect Candidate
  | EnterSelect
  | Next
  | Prev


init : Model
init =
  { query = ""
  , choices = Array.fromList []
  , selected = Nothing
  , highlighted = 1
  , lastAction = NoOp
  }


-- Update

update : Action -> Model -> Model
update action model =
  let select f =
        { model |
          query = f
        , selected = Just f
        , choices = Array.empty
        }
  in
  case action of
    NoOp ->
      model

    Query t ->
      { model |
        query = t
      , choices = mkChoices t
      , highlighted = 1
      , selected = Nothing
      }

    ClickSelect f ->
      select f

    EnterSelect ->
        let mf = Array.get model.highlighted model.choices
        in
          case mf of
            Nothing -> model
            Just f -> select f

    Next ->
      if model.highlighted == Array.length model.choices
      then model
      else { model | highlighted = model.highlighted + 1}

    Prev ->
      if model.highlighted == 1
      then model
      else {model | highlighted = model.highlighted - 1}


view : Signal.Address Action -> Model -> Html
view addr model =
  let
    handleKeyDown code =
      Signal.message addr <|
            case code of
              38 -> Prev
              40 -> Next
              13 -> EnterSelect
              _ -> NoOp

    queryInput =
      input [ on "input" targetValue (Signal.message addr << Query)
            , onCustomKeyDown handleKeyDown
            , value model.query
            , autofocus True
            ]
            []
  in
  case model.selected of
    Just f ->
      div []
          [ queryInput
          , div []
                [text f]
          ]
    Nothing ->
      let
        fff =
          Array.toIndexedList model.choices
          |> List.map (\(idx, e) -> (idx == model.highlighted, e))
        rendered =
          List.map
                (\(hl, f) ->
                  viewItem addr model.query hl f)
                    fff
      in
      div []
          [ queryInput
          , ul [] rendered
          ]

viewItem
  : Signal.Address Action
  -> String
  -> Bool -- isHighlighted
  -> Candidate
  -> Html
viewItem addr query hl f =
    let attrs = [onClick addr (ClickSelect f)]
        hlStyle = style [("background-color", "salmon")]
        i = getIndex query f
        qLength = String.length query
        start = String.left i f
        mid = String.slice i (i + qLength) f
        end = String.dropLeft (i + qLength) f
        person =
          span [] [
            text start
            , strong [] [text mid]
            , text end
          ]
    in
    li (if hl then hlStyle::attrs else attrs)
    [person]

matches : String -> Candidate -> Bool
matches s f =
  String.contains (String.toLower s) (String.toLower f)

mkChoices : String -> Array Candidate
mkChoices q =
  let
    earliestOccurrence q a b =
      let
        ia = getIndex q a
        ib = getIndex q b
      in
        compare ia ib
  in
    case q of
      "" -> Array.empty

      s ->
        candidates
        |> Array.toList
        |> List.filter (matches s)
        |> List.sortWith (earliestOccurrence q)
        |> Array.fromList


getIndex : String -> String -> Int
getIndex subs s =
    let
      mi = String.indices (String.toLower subs) (String.toLower s)
           |> List.head
    in
      Maybe.withDefault -1 mi


-- Data

candidates : Array.Array Candidate
candidates =
  Array.fromList [ "Ayman"
                 , "Jesus"
                 , "Dave"
                 , "DJ"
                 , "Daniel"
                 , "Dean"
                 ]


-- Debug

withDebug : (a -> b -> c) -> a -> b -> c
withDebug update action model =
  Debug.watch "State" (update action model)

withLast
  : (a -> b -> { d | lastAction : c })
  -> a
  -> b
  -> { d | lastAction : a }
withLast update action model =
    let m2 = update action model
    in
    {m2 | lastAction = action}


-- Utils

onCustomKeyDown : (Int -> Signal.Message) -> Attribute
onCustomKeyDown =
  let
    options = {preventDefault = True, stopPropagation = False}
    isOneOf xs code =
      if List.member code xs
      then Ok code
      else Err "not handling that key"
  in
  onWithOptions
    "keydown"
      options
        (Json.customDecoder keyCode (isOneOf [13, 38, 40]))
