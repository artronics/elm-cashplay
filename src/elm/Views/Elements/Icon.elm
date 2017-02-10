module Views.Elements.Icon exposing (icon, small, medium, large)

import Html exposing (..)
import Html.Attributes exposing (..)


icon : List (Attribute msg) -> String -> Html msg
icon atr icn =
    i ([ class <| "fa fa-" ++ icn ] ++ atr) []


small : Attribute msg
small =
    class "fa-1x"


large : Attribute msg
large =
    class "fa-3x"


medium : Attribute msg
medium =
    class "fa-2x"
