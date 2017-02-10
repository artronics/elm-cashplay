port module Shared.WebCam exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as Encode
import Json.Decode as Decode
import Views.Elements.Icon as Icon exposing (icon)
import Views.Modal exposing (viewModal)
import Views.Elements.Button as Btn exposing (btn)


port webcam : WebcamConfigValue -> Cmd msg


port webcamOff : (() -> msg) -> Sub msg


port webcamReset : () -> Cmd msg


port webcamSnap : () -> Cmd msg


port webcamDataUri : (Decode.Value -> msg) -> Sub msg


type CameraState
    = On
    | Off


type alias Model =
    { cameraState : CameraState
    }


init : Model
init =
    { cameraState = Off
    }


type Msg
    = Webcam
    | WebcamOff ()
    | CancelCamera
    | StopPropagation
    | Snap
    | Ok
    | DataUri Decode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Webcam ->
            ( { model | cameraState = On }, webcam <| webcamConfigValue defaultConfig )

        WebcamOff _ ->
            ( model, Cmd.none )

        Snap ->
            ( model, webcamSnap () )

        DataUri uriValue ->
            ( { model | cameraState = Off }, Cmd.none )

        CancelCamera ->
            ( { model | cameraState = Off }, webcamReset () )

        Ok ->
            ( model, Cmd.none )

        StopPropagation ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ webcamDataUri DataUri
        , webcamOff WebcamOff
        ]


view : Model -> Html Msg
view model =
    div [ class "art-webcam" ]
        [ viewCameraModal model ]


viewCameraModal : Model -> Html Msg
viewCameraModal model =
    viewModal "camera-modal"
        "Take Photo"
        CancelCamera
        (div []
            [ viewWebcamPort
            , cameraButton model
            , buttonBar
            ]
        )


viewWebcamPort =
    div [ class "camera-viewport" ]
        [ div
            [ id <| .id defaultConfig
            , style
                [ ( "width", "640px" )
                , ( "height", "480px" )
                ]
            ]
            []
        ]


cameraButton : Model -> Html Msg
cameraButton model =
    div
        [ class "shot-btn"
        , if model.cameraState == Off then
            onClick Webcam
          else
            onClick Snap
        ]
        [ btn [] [ icon [ Icon.large ] "camera" ] ]


buttonBar : Html Msg
buttonBar =
    div [ class "controls" ]
        [ btn [ Btn.default, Btn.large, onClick CancelCamera, attribute "data-dismiss" "modal" ] [ text "Cancel" ]
        , btn [ Btn.primary, Btn.large, onClick Ok ] [ text "Ok" ]
        ]


type alias WebcamConfigValue =
    Encode.Value


type alias WebcamConfig =
    { id : String
    , width : Int
    , height : Int
    , destWidth : Int
    , destHeight : Int
    }


defaultConfig : WebcamConfig
defaultConfig =
    { id = "webcam-viewport"
    , width = 640
    , height = 480
    , destWidth = 640
    , destHeight = 480
    }


webcamConfigValue : WebcamConfig -> WebcamConfigValue
webcamConfigValue conf =
    Encode.object
        [ "id" => Encode.string conf.id
        , "width" => Encode.int conf.width
        , "height" => Encode.int conf.height
        , "dest_width" => Encode.int conf.destWidth
        , "dest_height" => Encode.int conf.destHeight
        ]


(=>) =
    (,)
