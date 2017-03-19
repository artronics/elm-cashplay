module Elements.Input exposing (inp, email, password, required)

import Html exposing (..)
import Html.Attributes exposing (..)


inp : List (Attribute msg) -> String -> String -> Html msg
inp atr lbl valMsg =
    div [ class "form-group" ]
        [ label [] [ text lbl ]
        , input ([ class "form-control", placeholder lbl ] ++ atr) []
        , small [ class "form-text" ] [ text valMsg ]
        ]


email : Attribute msg
email =
    type_ "email"


password : Attribute msg
password =
    type_ "password"


required : Attribute msg
required =
    Html.Attributes.required True
