module Views.Elements.Icon exposing (icon, small, medium, large)

import Html exposing (..)
import Html.Attributes exposing (..)


icon : List (Attribute msg) -> String -> Html msg
icon atr icn =
    span ([ class "icon" ] ++ atr)
        [ i [ class <| "fa fa-" ++ icn ] [] ]


small : Attribute msg
small =
    class "is-small"


large : Attribute msg
large =
    class "is-large"


medium : Attribute msg
medium =
    class "is-medium"
