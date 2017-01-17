module Views.Elements.Textfield exposing (txt, editable)

import Html exposing (..)
import Html.Attributes exposing (class, style)


type alias Label =
    String


txt : Label -> List (Attribute msg) -> List (Html msg) -> Html msg
txt lbl atr elm =
    div [ class "form-group" ]
        [ label [] [ text lbl ]
        , input (atr ++ [ class "form-control" ]) elm
        ]


editable : Bool -> Attribute msg
editable b =
    if b then
        style []
    else
        style
            [ ( "border", "none" )
            ]
