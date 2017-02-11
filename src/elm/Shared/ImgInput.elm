module Shared.ImgInput exposing (Model, init, Msg(..), update, subscriptions, view)

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


update : Msg -> Model -> String -> ( Model, Cmd Msg, Maybe String )
update msg model msgId =
    case msg of
        LoadCamera ->
            ( model, Cmd.none, Nothing )

        UploadFile ->
            ( model, Cmd.none, Nothing )

        WebcamMsg msg_ ->
            let
                ( newWebcam, cmd, dataUri ) =
                    Webcam.update msg_ model.webcam msgId
            in
                ( { model
                    | webcam = newWebcam
                  }
                , Cmd.map WebcamMsg cmd
                , dataUri
                )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map WebcamMsg <| Webcam.subscriptions model.webcam


view : Model -> String -> Maybe String -> Html Msg
view model msgId feedDataUri =
    div []
        [ ImgInputView.imgInput ( 320, 240 )
            feedDataUri
            ( LoadCamera, UploadFile )
            True
        , Html.map WebcamMsg <| Webcam.view model.webcam msgId
        ]
