import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Json.Decode as Json
import StartApp.Simple as StartApp


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
  , choices : List Candidate
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
  , choices = []
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
        , choices = []
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
        let mf = List.head <|
            List.drop (model.highlighted-1) model.choices
        in
          case mf of
            Nothing -> model
            Just f -> select f

    Next ->
      if model.highlighted == List.length model.choices
      then model
      else { model | highlighted = model.highlighted + 1}

    Prev ->
      if model.highlighted == 1
      then model
      else {model | highlighted = model.highlighted - 1}


view : Signal.Address Action -> Model -> Html
view addr model =
  let
    options = {preventDefault = True, stopPropagation = False}
    dec =
      (Json.customDecoder keyCode (\k ->
          if List.member k [13, 38, 40]
          then Ok k
          else Err "not handling that key"))
    queryInput =
      input
        [on "input" targetValue (Signal.message addr << Query)
        , onWithOptions "keydown" options dec (\k ->
            Signal.message addr <|
              case k of
                  38 -> Prev
                  40 -> Next
                  13 -> EnterSelect
                  _ -> NoOp)
        , value model.query
        , autofocus True
        ] []
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
        mapIndexed f xs = List.map2 f [1..List.length xs] xs
        rendered =
          mapIndexed
          (\i f ->
            viewFriend addr (i == model.highlighted)  model.query f)
          model.choices
      in
      div []
          [ queryInput
          , ul [] rendered
          ]

viewFriend
  : Signal.Address Action
  -> Bool
  -> String
  -> Candidate
  -> Html
viewFriend addr hl q f =
    let attrs = [onClick addr (ClickSelect f)]
        hlStyle = style [("background-color", "salmon")]
        i = getIndex q f
        qLength = String.length q
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

mkChoices : String -> List Candidate
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
      "" -> []
      s ->
        List.filter (matches s) candidates
        |> List.sortWith (earliestOccurrence q)


getIndex : String -> String -> Int
getIndex q x =
    let
      mi = List.head <| String.indices (String.toLower q) (String.toLower x)
    in
      Maybe.withDefault -1 mi -- Should never get this




-- Data

candidates : List Candidate
candidates =
  [ "Ayman"
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
