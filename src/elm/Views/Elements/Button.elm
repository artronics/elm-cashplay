module Views.Elements.Button exposing (btn, primary)

import Html exposing (..)
import Html.Attributes exposing (classList, class)
import Views.Elements.Style as Style exposing (..)


type Btn
    = Primary


btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn atr elm =
    button (atr ++ [ class "art-btn btn" ]) elm


primary : Attribute msg
primary =
    class <| "btn-" ++ (color Style.Primary)
