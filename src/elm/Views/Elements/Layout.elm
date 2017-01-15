module Views.Elements.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Views.Elements.Style as Style


hbox : List (Attribute msg) -> List (Html msg) -> Html msg
hbox atr elm =
    div (atr ++ [ class "art-hbox" ]) elm
