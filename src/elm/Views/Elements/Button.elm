module Views.Elements.Button exposing (btn, primary, default)

import Html exposing (..)
import Html.Attributes exposing (classList, class)
import Views.Elements.Style as Style exposing (..)


type Btn
    = Primary


btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn atr elm =
    button (atr ++ [ class "art-btn btn" ]) elm


default : Attribute msg
default =
    class <| "btn-" ++ (color Style.Default)


primary : Attribute msg
primary =
    class <| "btn-" ++ (color Style.Primary)
