module Views.Elements.Textfield exposing (txt, editable, horInput, Width(..))

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Label =
    String


type Width
    = Full
    | Half


txt : Label -> List (Attribute msg) -> List (Html msg) -> Html msg
txt lbl atr elm =
    div [ class "form-group" ]
        [ label [] [ text lbl ]
        , input (atr ++ [ class "form-control" ]) elm
        ]


horInput : String -> Width -> Maybe String -> List (Attribute msg) -> Html msg
horInput lbl width valMsg atr =
    div
        [ class "form-group col-sm-12"
        , class <|
            if width == Full then
                "col-md-12"
            else
                "col-md-6"
        , class
            (valMsg
                |> Maybe.map (\_ -> "has-error")
                |> Maybe.withDefault ""
            )
        ]
        [ label [ class "col-sm-3 control-label" ] [ text <| lbl ++ ":" ]
        , div [ class "col-sm-9" ]
            [ input
                ([ class "form-control"
                 , placeholder lbl
                 ]
                    ++ atr
                )
                []
            , span [ class "help-block" ]
                [ text
                    (valMsg
                        |> Maybe.withDefault ""
                    )
                ]
            ]
        ]


editable : Bool -> Attribute msg
editable b =
    if b then
        class ""
    else
        class "input-as-label"
