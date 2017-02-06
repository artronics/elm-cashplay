module Shared.PicListLoader exposing (Model, Msg, update, init, view, subscriptions)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import Views.ImgBox as ImgBox
import Shared.PicLoader as PicLoader


type alias Model =
    { picLoader : PicLoader.Model
    , pics : List PicLoader.DataUri
    }


init : Model
init =
    { picLoader = PicLoader.init
    , pics = []
    }


type Msg
    = PicLoaderMsg PicLoader.Msg


update : Msg -> Model -> ( Model, Cmd Msg, Maybe (List PicLoader.DataUri) )
update msg model =
    case msg of
        PicLoaderMsg msg_ ->
            let
                ( newPicLoader, cmd, picValue ) =
                    PicLoader.update msg_ model.picLoader "docs-camera"

                pics =
                    picValue |> Maybe.map (\p -> p :: model.pics) |> Maybe.withDefault model.pics
            in
                ( { model | picLoader = newPicLoader, pics = pics }, Cmd.none, Nothing )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map PicLoaderMsg <| PicLoader.subscriptions model.picLoader ]


decodePic : Decode.Value -> Maybe String
decodePic pic =
    Decode.decodeValue Decode.string pic |> Result.toMaybe


view : Model -> Maybe (List String) -> Html Msg
view model feedDataUris =
    let
        imgs =
            model.pics |> List.map (\p -> (decodePic p) |> Maybe.withDefault "") |> List.filter (\p -> p == "")
    in
        div []
            [ viewImgListBox model imgs "title" ]


viewImgListBox : Model -> List String -> String -> Html Msg
viewImgListBox model dataUris title =
    ul [ class "art-img-list-box" ]
        ((dataUris
            |> List.map (\d -> li [] [ Html.map PicLoaderMsg <| PicLoader.view model.picLoader "docs-camera" (Just d) ])
         )
            ++ [ li [] [ Html.map PicLoaderMsg <| PicLoader.view model.picLoader "docs-camera" Nothing ] ]
        )
