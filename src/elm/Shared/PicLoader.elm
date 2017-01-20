port module Shared.PicLoader exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)


type alias Model =
    {}


init : Model
init =
    {}


type Msg
    = OnAttach


update : Msg -> Model -> ( Model, Cmd Msg )
update msg webcam =
    case msg of
        OnAttach ->
            ( webcam, Cmd.none )


port attach : String -> Cmd msg


port snap : (String -> msg) -> Sub msg


view : Model -> Html Msg
view webcam =
    div [ class "art-customer-pic well" ]
        [ div [ class "art-upload-shot" ]
            [ i [ class "fa fa-2x fa-camera" ] []
            , i [ class "fa fa-2x fa-upload" ] []
            ]
        ]
