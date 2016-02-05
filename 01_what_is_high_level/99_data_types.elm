import Html exposing (..)

pure a = [a]

main : Html
main =
  div []
        (List.map
           ((pre []) << pure << text)
           [ toString val1
           , toString val2
           , toString val3
           , toString val4
           , toString val5
           , toString val6
           , toString val7
           , toString val8
           ])

val1 : Maybe Int
val1 = Just 2

type alias Person =
  { name : String
  , age : Int
  }

val2 : Maybe Person
val2 = Nothing

val3 : Person
val3 = Person "Bob" 32
val4 : Maybe Person
val4 = Just {name = "Alice", age = 23}

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
val6 = Bad { name = "Ayman", age = 27 } Megalomania

val7 : Character Person
val7 = Good (Person "Jamie" 30) Empathy

 -- the type and one of the data constructors can actually
 -- share the same name. That is because type and values
 -- live in separate namespaces
type Ty = Ty | Another

val8 : Ty
val8 = Ty
