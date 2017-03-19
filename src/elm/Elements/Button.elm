module Elements.Button exposing (btn, primary, default, submit, large, iconBtn, outlinePrimary)

import Html exposing (..)
import Html.Attributes exposing (classList, class, type_)
import Elements.Icon as Icon exposing (icon)


btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn atr elm =
    button (atr ++ [ class "btn" ]) elm


iconBtn : List (Attribute msg) -> String -> String -> Html msg
iconBtn atr lbl icn =
    button (atr ++ [ class "btn art-icon-btn" ]) [ icon [] icn, text lbl ]


default : Attribute msg
default =
    class <| "btn-default"


submit : Attribute msg
submit =
    type_ "submit"


large : Attribute msg
large =
    class <| "btn-lg"


primary : Attribute msg
primary =
    class <| "btn-primary"


outlinePrimary : Attribute msg
outlinePrimary =
    class <| "btn-outline-primary"
