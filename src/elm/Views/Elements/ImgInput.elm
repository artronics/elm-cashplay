module Views.Elements.ImgInput exposing (imgInput)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Views.Elements.Icon as Icon exposing (icon)


type alias Size =
    ( Int, Int )


type alias DataUri =
    String


imgInput : Size -> Maybe DataUri -> ( msg, msg ) -> Bool -> Html msg
imgInput size dataUri messages editable =
    let
        empty =
            dataUri == Nothing
    in
        div [ sizeStyle size, class "box art-img-input" ]
            [ dropArea size dataUri messages
            ]


dropArea : Size -> Maybe DataUri -> ( msg, msg ) -> Html msg
dropArea size dataUri ( loadCamera, uploadFile ) =
    div [ sizeStyle size, class "drop-area" ]
        [ closeImg False
        , emptyText (not <| dataUri == Nothing) size
        , buttonBar False loadCamera uploadFile
        , img [ class "img", width 320, height 240, src (dataUri |> Maybe.withDefault "") ] []
        ]


emptyText : Bool -> Size -> Html msg
emptyText hidden ( w, h ) =
    p [ class "text-center empty-text", classList [ ( "hidden", hidden ) ] ] [ text "Press Camera to take a Photo or drop your file here. " ]


closeImg : Bool -> Html msg
closeImg hidden =
    i [ class "fa fa-2x fa-times close" ] []


buttonBar : Bool -> msg -> msg -> Html msg
buttonBar hidden loadCamera uploadFile =
    div [ class "shot-or-upload", classList [ ( "hidden", hidden ) ] ]
        [ div []
            [ div [ onClick uploadFile ] [ icon [ Icon.medium ] "upload" ]
            , div [ onClick loadCamera, attribute "data-toggle" "modal", attribute "data-target" "#camera-modal" ] [ icon [ Icon.medium ] "camera" ]
            ]
        ]


sizeStyle : Size -> Attribute msg
sizeStyle ( w, h ) =
    style [ ( "width", toString w ++ "px" ), ( "height", toString h ++ "px" ) ]