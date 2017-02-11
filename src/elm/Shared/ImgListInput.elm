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


view : Model -> Maybe (List String) -> Html Msg
view model feedDataUris =
    let
        imgs =
            feedDataUris |> Maybe.withDefault [] |> List.filter (\p -> p == "")
    in
        div []
            [ viewImgListBox model imgs "title" ]


viewImgListBox : Model -> List String -> String -> Html Msg
viewImgListBox model dataUris title =
    ul [ class "art-img-list-box" ]
        ((dataUris
            |> List.map (\d -> li [] [ Html.map ImgInputMsg <| ImgInput.view model.imgInput (Just d) ])
         )
            ++ [ li [] [ Html.map ImgInputMsg <| ImgInput.view model.imgInput Nothing ] ]
        )
