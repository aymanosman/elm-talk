import Html exposing (..)
import Html.Attributes as A
import Check exposing (..)
import Check.Investigator exposing (..)
import List exposing (length, reverse)

main : Html
main =
  pre
    [ A.style [("width", "100%"), ("position", "relative")]]
    [text (toString result)]

result : Evidence
result = quickCheck suite_reverse

suite_reverse : Claim
suite_reverse =
  suite "List Reverse Suite"
    [ claim_reverse_twice_yields_original
    , claim_reverse_does_not_modify_length
    , claim_multiplication_division_inverse
    ]

claim_reverse_twice_yields_original : Claim
claim_reverse_twice_yields_original =
  claim
    "Reversing a list twice yields the original list"
    `that`
    (\list -> reverse (reverse list))
    `is`
    (identity)
    `for`
    list int


claim_reverse_does_not_modify_length : Claim
claim_reverse_does_not_modify_length =
  claim
    "Reversing a list does not modify its length"
  `that`
    (\list -> length (reverse list))
  `is`
    (\list -> length list)
  `for`
  list int



claim_multiplication_division_inverse : Claim
claim_multiplication_division_inverse =
  claim
  "Multiplication and division are inverse operations"
  `that`
  (\(x, y) -> if y == 0 then x else x * y / y)
  `is`
  (\(x, y) -> x)
  `for`
  tuple (float, float)
