module Views.ImgBox exposing (viewImgBox)

import Html exposing (..)
import Html.Attributes exposing (src, class, style)


viewImgBox : String -> Html msg
viewImgBox dataUri =
    div [ style [ ( "width", "320px" ), ( "height", "240px" ) ] ]
        [ if dataUri == "" then
            p [] [ text "loading ..." ]
          else
            img [ src dataUri ] []
        ]
