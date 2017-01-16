module Views.Elements.Textfield exposing (txt)

import Html exposing (..)
import Html.Attributes exposing (class)


type alias Label =
    String


txt : Label -> List (Attribute msg) -> List (Html msg) -> Html msg
txt lbl atr elm =
    div [ class "form-group" ]
        [ label [] [ text lbl ]
        , input (atr ++ [ class "form-control" ]) elm
        ]
