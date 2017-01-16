module Views.Elements.Label exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)


type alias Icon =
    String


type alias Label =
    String


labelIcon : Label -> Icon -> Html msg
labelIcon lbl icn =
    span [ class "art-lbl" ]
        [ i [ class <| "fa " ++ "fa-" ++ icn ] []
        , span [] [ text lbl ]
        ]
