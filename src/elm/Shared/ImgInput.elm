module Shared.ImgInput exposing (Model, init, Msg, update, subscriptions, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Views.Elements.ImgInput as ImgInputView
import Shared.WebCam as Webcam


type alias Model =
    { webcam : Webcam.Model
    , dataUri : Maybe String
    }


init : Model
init =
    { webcam = Webcam.init
    , dataUri = Nothing
    }


type Msg
    = LoadCamera
    | UploadFile
    | WebcamMsg Webcam.Msg


update : Msg -> Model -> ( Model, Cmd Msg, Maybe String )
update msg model =
    case msg of
        LoadCamera ->
            ( model, Cmd.none, Nothing )

        UploadFile ->
            ( model, Cmd.none, Nothing )

        WebcamMsg msg_ ->
            let
                ( newWebcam, cmd, dataUri ) =
                    Webcam.update msg_ model.webcam
            in
                ( { model | webcam = newWebcam, dataUri = dataUri |> Maybe.map (\d -> Just d) |> Maybe.withDefault model.dataUri }, Cmd.map WebcamMsg cmd, dataUri )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map WebcamMsg <| Webcam.subscriptions model.webcam


view : Model -> Html Msg
view model =
    div []
        [ ImgInputView.imgInput ( 320, 240 )
            model.dataUri
            ( LoadCamera, UploadFile )
            True
        , Html.map WebcamMsg <| Webcam.view model.webcam
        ]
