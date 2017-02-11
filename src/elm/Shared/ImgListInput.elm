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


update : Msg -> Model -> String -> ( Model, Cmd Msg )
update msg model msgId =
    case msg of
        ImgInputMsg msg_ ->
            let
                ( newImgInput, cmd, dataUri ) =
                    ImgInput.update msg_ model.imgInput msgId
            in
                ( { model | imgInput = newImgInput }, Cmd.map ImgInputMsg cmd ) |> Debug.log "imginput"


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map ImgInputMsg <| ImgInput.subscriptions model.imgInput


view : Model -> String -> Maybe (List String) -> Html Msg
view model msgId feedDataUris =
    let
        imgs =
            feedDataUris |> Maybe.withDefault [] |> List.filter (\p -> p == "")
    in
        div []
            [ viewImgListBox model msgId imgs "title" ]


viewImgListBox : Model -> String -> List String -> String -> Html Msg
viewImgListBox model msgId dataUris title =
    ul [ class "art-img-list-box" ]
        ((dataUris
            |> List.map (\d -> li [] [ Html.map ImgInputMsg <| ImgInput.view model.imgInput msgId (Just d) ])
         )
            ++ [ li [] [ Html.map ImgInputMsg <| ImgInput.view model.imgInput msgId Nothing ] ]
        )
