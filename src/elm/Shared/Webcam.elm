port module Shared.Webcam exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as Encode
import Json.Decode as Decode
import Elements.Button as Btn exposing (btn)


port webcamOn : WebcamConfigValue -> Cmd msg


port webcamOff : () -> Cmd msg


port webcamSnap : String -> Cmd msg


port webcamDataUri : (Decode.Value -> msg) -> Sub msg


turnOnWebcam : String -> Cmd msg
turnOnWebcam id =
    webcamOn <| webcamConfigValue <| defaultConfig id


turnOffWebcam : Cmd msg
turnOffWebcam =
    webcamOff ()


type alias Model =
    {}


init : Model
init =
    {}


type Msg
    = TurnOnWebcam String
    | TurnOffWebcam
    | Snap String
    | DataUri Decode.Value


update : Msg -> Model -> ( Model, Cmd Msg, Maybe String )
update msg model =
    case msg of
        TurnOnWebcam id ->
            ( model, turnOnWebcam id, Nothing )

        TurnOffWebcam ->
            ( model, turnOffWebcam, Nothing )

        Snap id ->
            ( model, webcamSnap id, Nothing )

        DataUri value ->
            let
                dataUri =
                    decodeDataUri value
            in
                ( model, Cmd.none, dataUri )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ webcamDataUri DataUri
        ]


view : Model -> String -> Html Msg
view model id_ =
    div []
        [ div [ id id_ ] []
        , div [ onClick <| TurnOnWebcam id_ ] [ text "inja" ]
        , btn [ onClick <| Snap id_ ] [ text "SNAP" ]
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


decodeDataUri : Decode.Value -> Maybe String
decodeDataUri value =
    Decode.decodeValue (Decode.field "data_uri" (Decode.nullable Decode.string)) value
        |> Result.toMaybe
        |> Maybe.withDefault Nothing
