module Shared.ImgListInput exposing (Model, init, Msg, update, view, subscriptions)

import Html exposing (..)
import Html.Attributes exposing (..)
import Shared.ImgInput as ImgInput


type alias Model =
    { imgInput : ImgInput.Model
    }


init : Model
init =
    { imgInput = ImgInput.init
    }


type Msg
    = ImgInputMsg ImgInput.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ImgInputMsg msg_ ->
            let
                ( newImgInput, cmd, dataUri ) =
                    ImgInput.update msg_ model.imgInput
            in
                ( { model | imgInput = newImgInput }, Cmd.map ImgInputMsg cmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map ImgInputMsg <| ImgInput.subscriptions model.imgInput


view : Model -> Html Msg
view model =
    div [] [ text "pic list" ]
