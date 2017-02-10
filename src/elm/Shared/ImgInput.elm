module Shared.ImgInput exposing (Model, init, Msg, update, subscriptions, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Views.Elements.ImgInput as ImgInputView
import Shared.WebCam as Webcam


type alias Model =
    { webcam : Webcam.Model
    }


init : Model
init =
    { webcam = Webcam.init
    }


type Msg
    = LoadCamera
    | UploadFile
    | WebcamMsg Webcam.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadCamera ->
            ( model, Cmd.none )

        UploadFile ->
            ( model, Cmd.none )

        WebcamMsg msg_ ->
            let
                ( newWebcam, cmd ) =
                    Webcam.update msg_ model.webcam
            in
                ( { model | webcam = newWebcam }, Cmd.map WebcamMsg cmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map WebcamMsg <| Webcam.subscriptions model.webcam


view : Model -> Html Msg
view model =
    div []
        [ ImgInputView.imgInput ( 320, 240 )
            Nothing
            ( LoadCamera, UploadFile )
            True
        , Html.map WebcamMsg <| Webcam.view model.webcam
        ]
