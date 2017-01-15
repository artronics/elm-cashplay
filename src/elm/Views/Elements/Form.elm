module Views.Elements.Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (classList, class)


type Color
    = Primary


type Btn
    = Primary


btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn atr elm =
    button (atr ++ [ classList [ "art-btn", "btn" ] ]) elm


primary : Attribute msg
primary =
    class <| "btn-" ++ (color Primary)


color : Color -> String
color clr =
    case clr of
        Primary ->
            "primary"
