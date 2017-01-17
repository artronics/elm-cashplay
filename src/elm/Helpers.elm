module Helpers exposing (..)

import Dict as Dict exposing (Dict)


maybeToBool : Maybe a -> Bool
maybeToBool m =
    m |> Maybe.map (\_ -> True) |> Maybe.withDefault False


resourceToDict : (a -> String) -> List a -> Dict String a
resourceToDict keygen res =
    Dict.fromList
        (res
            |> List.map (\r -> ( keygen r, r ))
        )
