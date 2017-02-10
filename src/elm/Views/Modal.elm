module Views.Modal exposing (viewModal)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


viewModal : String -> String -> msg -> Html msg -> Html msg
viewModal id_ title dismissMsg body =
    div [ class "modal fade", id id_, tabindex -1, attribute "role" "dialog" ]
        [ div [ class "modal-dialog modal-lg", attribute "role" "document" ]
            [ div [ class "modal-content" ]
                [ div [ class "modal-header" ]
                    [ button [ type_ "button", class "close", onClick dismissMsg, attribute "data-dismiss" "modal" ] [ i [ class "fa fa-times" ] [] ]
                    , h4 [] [ text title ]
                    ]
                , div [ class "modal-body" ]
                    [ body ]
                ]
            ]
        ]
