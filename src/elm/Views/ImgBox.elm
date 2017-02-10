module Views.ImgBox exposing (viewImgBox)

import Html exposing (..)
import Html.Attributes exposing (..)
import Views.Modal exposing (viewModal)


viewImgBox : String -> String -> msg -> Html msg
viewImgBox dataUri title dismissMsg =
    div [ class "art-img-box" ]
        [ if dataUri == "" then
            div [ class "loading" ]
                [ i [ class "fa fa-spinner fa-pulse fa-3x fa-fw" ]
                    []
                , h5 []
                    [ text "Loading ..." ]
                ]
          else
            div [ class "img-box" ]
                [ img [ src dataUri, width 320, height 240, attribute "data-toggle" "modal", attribute "data-target" "#cus-img" ] []
                , h5 [ class "help-text" ] [ text "Click on image to enlarge." ]
                ]
        , viewModal "cus-img" title dismissMsg (div [] [ img [ src dataUri ] [] ])
        ]
