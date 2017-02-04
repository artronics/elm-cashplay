module Views.ImgBox exposing (viewImgBox)

import Html exposing (..)
import Html.Attributes exposing (..)


viewImgBox : String -> String -> Html msg
viewImgBox dataUri title =
    div [ style [ ( "width", "320px" ), ( "height", "240px" ) ] ]
        [ if dataUri == "" then
            p [] [ text "loading ..." ]
          else
            div []
                [ img [ src dataUri, width 320, height 240, attribute "data-toggle" "modal", attribute "data-target" "#cus-img" ] []
                , p [] [ text "Click on image to enlarge." ]
                ]
        , viewModal "cus-img" title (div [] [ img [ src dataUri ] [] ])
        ]


viewModal : String -> String -> Html msg -> Html msg
viewModal id_ title body =
    div [ class "modal fade", id id_, tabindex -1, attribute "role" "dialog" ]
        [ div [ class "modal-dialog modal-lg", attribute "role" "document" ]
            [ div [ class "modal-content" ]
                [ div [ class "modal-header" ]
                    [ button [ type_ "button", class "close", attribute "data-dismiss" "modal" ] [ i [ class "fa fa-times" ] [] ]
                    , h4 [] [ text title ]
                    ]
                , div [ class "modal-body" ]
                    [ body ]
                ]
            ]
        ]
