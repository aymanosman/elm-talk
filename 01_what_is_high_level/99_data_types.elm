import Html exposing (..)

pure a = [a]
v s val = s ++ toString val

main : Html
main =
  div []
        (List.map
           ((pre []) << pure << text)
           [ v "1: " val1
           , v "2: " val2
           , v "3: " val3
           , v "4: " val4
           , v "5: " val5
           , v "6: " val6
           , v "7: " val7
           , v "8: " val8
           ])

-- type Maybe a = Nothing | Just a
val1 : Maybe Int
val1 = Just 2

type alias Person =
  { name : String
  , age : Int
  }

val2 : Person
val2 = Person "Bob" 32 -- same as {name="Bob", age=32}

val3 : Maybe Person
val3 = Nothing
val4 : Maybe Person -- same as Maybe {name : String, age : Int}
val4 = Just {name = "Alice", age = 23} -- same as Just (Person "Alice" 23)

-- X is a type, A and B are `data constructors`
type X
  = A Int
  | B String

val5 : List X
val5 = [A 2, B "foo"]

type Character a
  = Good a Reason
  | Bad a Reason

type Reason
  = Megalomania
  | Empathy

val6 : Character Person
val6 = Bad { name = "Mallory", age = 27 } Megalomania

val7 : Character Person
val7 = Good (Person "Angela" 30) Empathy

 -- the type and one of the data constructors can actually
 -- share the same name. That is because types and values
 -- live in separate namespaces
type Ty = Ty | Another

val8 : Ty
val8 = Ty
