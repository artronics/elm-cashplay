module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = Home
    | Cashplay
    | NotFound


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Home top
        , map Cashplay (s "cashplay")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFound
