module Helpers exposing (..)

maybeToBool : Maybe a -> Bool
maybeToBool m =
    m |> Maybe.map (\_ -> True) |> Maybe.withDefault False


