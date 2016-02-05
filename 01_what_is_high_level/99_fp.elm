import Html exposing (..)

main =
  (text << toString) val

val =
  add3 2

-- Currying
add x y = x + y
add3 = add 3

{-

Think of the above when you see this common pattern:

view : Address -> Model -> Html
view addr model = ...

Signal.map (view addr) signalOfModels


If you look at the type signature of the `view` function,
you see that it is a function that takes an Address then
RETURNS A FUNCTION that takes a Model that finally returns
a result of type Html.


You can think of the uncurried version as being

view : (Address, Model) -> Html

Like you would find in a other languages. In fact `uncurry`
exists as a function

-}

add' = uncurry add

val' = add' (23, 42)

