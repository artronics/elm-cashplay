port module Shared.WebCam exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as Encode
import Json.Decode as Decode
import Views.Elements.Icon as Icon exposing (icon)
import Views.Modal exposing (viewModal)
import Views.Elements.Button as Btn exposing (btn)
import String


port webcam : WebcamConfigValue -> Cmd msg


port webcamOff : (() -> msg) -> Sub msg


port webcamReset : () -> Cmd msg


port webcamSnap : String -> Cmd msg


port webcamDataUri : (Decode.Value -> msg) -> Sub msg


type CameraState
    = On
    | Off


type alias Model =
    { cameraState : CameraState
    , dataUri : Maybe String
    }


init : Model
init =
    { cameraState = Off
    , dataUri = Nothing
    }


type Msg
    = Webcam
    | WebcamOff ()
    | CancelCamera
    | Snap
    | Ok
    | DataUri Decode.Value


update : Msg -> Model -> String -> ( Model, Cmd Msg, Maybe String )
update msg model msgId =
    case msg of
        Webcam ->
            ( { model | cameraState = On }, webcam <| webcamConfigValue <| defaultConfig msgId, Nothing )

        WebcamOff _ ->
            ( model, Cmd.none, Nothing )

        Snap ->
            ( model, webcamSnap msgId, Nothing )

        DataUri uriValue ->
            let
                dataUri =
                    decodeDataUri uriValue

                originId =
                    decodeMsgId uriValue |> Maybe.withDefault "unknown"

                updateDU m id du =
                    if originId == id then
                        du
                    else
                        Nothing
            in
                ( { model | cameraState = Off, dataUri = updateDU model msgId dataUri }, Cmd.none, Nothing )

        CancelCamera ->
            ( { model | cameraState = Off }, webcamReset (), Nothing )

        Ok ->
            ( model
            , webcamReset ()
            , model.dataUri
            )


decodeDataUri : Decode.Value -> Maybe String
decodeDataUri value =
    Decode.decodeValue (Decode.field "data_uri" (Decode.nullable Decode.string)) value
        |> Result.toMaybe
        |> Maybe.withDefault Nothing


decodeMsgId : Decode.Value -> Maybe String
decodeMsgId value =
    Decode.decodeValue (Decode.field "msg_id" Decode.string) value |> Result.toMaybe


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ webcamDataUri DataUri
        , webcamOff WebcamOff
        ]


view : Model -> String -> Html Msg
view model msgId =
    div [ class "art-webcam" ]
        [ viewCameraModal model msgId ]


viewCameraModal : Model -> String -> Html Msg
viewCameraModal model msgId =
    viewModal "camera-modal"
        "Take Photo"
        CancelCamera
        (div []
            [ viewWebcamPort msgId
            , cameraButton model
            , buttonBar model
            ]
        )


viewWebcamPort msgId =
    div [ class "camera-viewport" ]
        [ div
            [ id msgId
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


buttonBar : Model -> Html Msg
buttonBar model =
    div [ class "controls" ]
        [ btn [ Btn.default, Btn.large, onClick CancelCamera, attribute "data-dismiss" "modal" ] [ text "Cancel" ]
        , btn
            [ Btn.primary
            , Btn.large
            , onClick Ok
            , attribute "data-dismiss" "modal"
            , disabled <| model.dataUri == Nothing
            ]
            [ text "Ok" ]
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


defaultConfig : String -> WebcamConfig
defaultConfig msgId =
    { id = msgId
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
