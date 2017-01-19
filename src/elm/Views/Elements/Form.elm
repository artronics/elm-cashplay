module Views.Elements.Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (classList, class)


frm : List (Attribute msg) -> List (Html msg) -> Html msg
frm atr elm =
    form atr elm


editable : Bool -> Attribute msg
editable b =
    if b then
        class ""
    else
        class "form-as-label"
