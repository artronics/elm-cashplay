module Views.Elements.Button exposing (btn, primary, default, large)

import Html exposing (..)
import Html.Attributes exposing (classList, class)


btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn atr elm =
    button (atr ++ [ class "btn" ]) elm


default : Attribute msg
default =
    class <| "btn-default"


large : Attribute msg
large =
    class <| "btn-lg"


primary : Attribute msg
primary =
    class <| "btn-primary"
