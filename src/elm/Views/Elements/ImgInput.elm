module Views.Elements.ImgInput exposing (imgInput)

import Html exposing (..)
import Html.Attributes exposing (..)
import Views.Elements.Icon as Icon exposing (icon)


type alias Size =
    ( Int, Int )


type alias DataUri =
    String


imgInput : Size -> Maybe DataUri -> Bool -> Html msg
imgInput size dataUri editable =
    let
        empty =
            dataUri == Nothing
    in
        div [ sizeStyle size, class "box art-img-input" ]
            [ dropArea size
            ]


dropArea : Size -> Html msg
dropArea size =
    div [ sizeStyle size, class "drop-area" ]
        [ closeImg False
        , emptyText False size
        , buttonBar False
        ]


emptyText : Bool -> Size -> Html msg
emptyText hidden ( w, h ) =
    p [ class "text-center empty-text" ] [ text "Press Camera to take a Photo or drop your file here. " ]


closeImg : Bool -> Html msg
closeImg hidden =
    a [ class "delete" ] []


buttonBar : Bool -> Html msg
buttonBar hidden =
    div [ class "shot-or-upload", classList [ ( "hidden", hidden ) ] ]
        [ div []
            [ div [] [ icon [ Icon.medium ] "upload" ]
            , div [] [ icon [ Icon.medium ] "camera" ]
            ]
        ]


sizeStyle : Size -> Attribute msg
sizeStyle ( w, h ) =
    style [ ( "width", toString w ++ "px" ), ( "height", toString h ++ "px" ) ]
