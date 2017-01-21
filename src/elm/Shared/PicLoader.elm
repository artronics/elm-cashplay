port module Shared.PicLoader exposing (..)

import Html exposing (..)
import Html.Events exposing (on, onClick)
import Html.Attributes exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Task
import FileReader exposing (..)
import MimeType exposing (MimeType(..))
import Shared.DragDropModel as DragDrop exposing (Msg(Drop), dragDropEventHandlers, HoverState(..))
import Debug


type alias DataUri =
    Decode.Value


type alias Files =
    List NativeFile


type WebcamState
    = Off
    | On


type alias Model =
    { webcamState : WebcamState
    , dnDModel : DragDrop.HoverState
    , imageLoadError : Maybe FileReader.Error
    }


init : Model
init =
    { webcamState = Off
    , dnDModel = DragDrop.init
    , imageLoadError = Nothing
    }


type Msg
    = OnConfig
    | OnAttached ()
    | OnConfiged ()
    | Snap
    | Snapped DataUri
    | DnD DragDrop.Msg
    | FileData (Result Error FileContentDataUrl)
    | FilesSelect Files


type alias WebcamConfigValue =
    Encode.Value


type alias WebcamConfig =
    { width : Int
    , height : Int
    , destWidth : Int
    , destHeight : Int
    }


defaultConfig : WebcamConfig
defaultConfig =
    { width = 320
    , height = 240
    , destWidth = 320
    , destHeight = 240
    }


webcamConfigValue : WebcamConfig -> WebcamConfigValue
webcamConfigValue conf =
    Encode.object
        [ "width" => Encode.int conf.width
        , "height" => Encode.int conf.height
        , "dest_widht" => Encode.int conf.destWidth
        , "dest_height" => Encode.int conf.destHeight
        ]


(=>) =
    (,)


update : Msg -> Model -> ( Model, Cmd Msg, Maybe DataUri )
update msg picLoader =
    case msg of
        OnConfig ->
            ( picLoader
            , webcamConfig (webcamConfigValue defaultConfig)
            , Nothing
            )

        OnConfiged _ ->
            ( picLoader, webcamAttach "#my-camera", Nothing )

        OnAttached _ ->
            ( { picLoader | webcamState = On }, Cmd.none, Nothing )

        Snap ->
            ( { picLoader | webcamState = Off }, snap (), Nothing )

        Snapped dataUri ->
            ( picLoader, Cmd.none, Just dataUri )

        -- Case drop. Let the DnD library update it's model and emmit the loading effect
        DnD (Drop files) ->
            ( { picLoader
                | dnDModel = DragDrop.update (Drop files) picLoader.dnDModel
              }
            , loadFirstFile files
            , Nothing
            )

        -- Other DnD cases. Let the DnD library update it's model.
        DnD a ->
            ( { picLoader
                | dnDModel = DragDrop.update a picLoader.dnDModel
              }
            , Cmd.none
            , Nothing
            )

        FilesSelect fileInstances ->
            let
                cmd =
                    fileInstances
                        |> List.head
                        |> Maybe.map (\f -> readTextFile f)
                        |> Maybe.withDefault Cmd.none
            in
                ( picLoader, cmd, Nothing )

        FileData (Ok val) ->
            ( picLoader, Cmd.none, Just val )

        FileData (Err err) ->
            ( { picLoader | imageLoadError = Just err }, Cmd.none, Nothing )


port webcamAttach : String -> Cmd msg


port webcamAttached : (() -> msg) -> Sub msg


port webcamConfig : WebcamConfigValue -> Cmd msg


port webcamConfiged : (() -> msg) -> Sub msg


port snap : () -> Cmd msg


port snapped : (DataUri -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ webcamAttached OnAttached
        , webcamConfiged OnConfiged
        , snapped Snapped
        ]


view : Model -> Maybe String -> Html Msg
view picLoader feedDataUri =
    let
        empty =
            picLoader.webcamState == Off && feedDataUri == Nothing
    in
        div ([ class "art-customer-pic" ])
            [ div [ styleWidthHeight, classList [ ( "empty", empty ) ] ]
                [ p [ classList [ ( "hidden", not empty ) ], class "help-text text-center" ] [ text "Press Camera to take a Photo or drop your file here. " ]
                , viewWebcamLive picLoader
                , viewImageIfCamOff picLoader feedDataUri
                ]
            , viewButtonBar picLoader
            , Html.map DnD <| div ([ class "drop-area" ] ++ dragDropEventHandlers) []
            , viewError picLoader
            ]


viewImageIfCamOff : Model -> Maybe String -> Html Msg
viewImageIfCamOff picLoader dataUri =
    div [ classList [ ( "hidden", picLoader.webcamState == On ) ] ]
        [ dataUri
            |> Maybe.map (\uri -> img [ src uri, width <| .width defaultConfig, height <| .height defaultConfig ] [])
            |> Maybe.withDefault (span [] [])
        ]


viewWebcamLive : Model -> Html Msg
viewWebcamLive picLoader =
    div
        [ id "my-camera", classList [ ( "hidden", picLoader.webcamState == Off ) ] ]
        []


viewButtonBar : Model -> Html Msg
viewButtonBar picLoader =
    div [ class "art-upload-shot" ]
        -- here is the buttons bar. if wecam is off the camera button is for Snap
        [ i
            [ class "fa fa-2x fa-camera"
            , onClick <|
                if picLoader.webcamState == Off then
                    OnConfig
                else
                    Snap
            ]
            []
        , i [ class "fa fa-2x fa-upload", classList [ ( "hidden", picLoader.webcamState == On ) ] ]
            [ input [ type_ "file", class "file-input", onchange FilesSelect ] [] ]
        ]


styleWidthHeight =
    style
        [ ( "width", (toString <| .width defaultConfig) ++ "px" )
        , ( "height", (toString <| .height defaultConfig) ++ "px" )
        ]


viewError : Model -> Html Msg
viewError picLoader =
    div []
        [ p [] [ text (picLoader.imageLoadError |> Maybe.map (\e -> FileReader.prettyPrint e) |> Maybe.withDefault "") ] ]


onchange action =
    on
        "change"
        (Decode.map action parseSelectedFiles)



--TASKS


dropAllowedForFile : NativeFile -> Bool
dropAllowedForFile file =
    case file.mimeType of
        Nothing ->
            False

        Just mimeType ->
            case mimeType of
                MimeType.Image _ ->
                    True

                _ ->
                    False


loadFirstFile : List NativeFile -> Cmd Msg
loadFirstFile =
    loadFirstFileWithLoader loadData


loadData : FileRef -> Cmd Msg
loadData file =
    FileReader.readAsDataUrl file
        |> Task.map Ok
        |> Task.onError (Task.succeed << Err)
        |> Task.perform FileData



-- small helper method to do nothing if 0 files were dropped, otherwise load the first file


loadFirstFileWithLoader : (FileRef -> Cmd Msg) -> List NativeFile -> Cmd Msg
loadFirstFileWithLoader loader files =
    let
        maybeHead =
            List.head <|
                List.map .blob
                    (List.filter dropAllowedForFile files)
    in
        case maybeHead of
            Nothing ->
                Cmd.none

            Just file ->
                loader file



-- For file select


readTextFile : NativeFile -> Cmd Msg
readTextFile fileValue =
    readAsDataUrl fileValue.blob
        |> Task.attempt FileData
