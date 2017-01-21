port module Shared.PicLoader exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Task
import FileReader exposing (..)
import MimeType exposing (MimeType(..))
import Shared.DragDropModel as DragDrop exposing (Msg(Drop), dragDropEventHandlers, HoverState(..))
import Debug


type alias DataUri =
    String


type WebcamState
    = Off
    | On


type alias Model =
    { dataUri : Maybe DataUri
    , uploadDataUri : Maybe FileContentDataUrl
    , webcamState : WebcamState
    , dnDModel : DragDrop.HoverState
    , imageLoadError : Maybe FileReader.Error
    }


init : Model
init =
    { dataUri = Nothing
    , uploadDataUri = Nothing
    , webcamState = Off
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg picLoader =
    case msg of
        OnConfig ->
            picLoader
                ! [ webcamConfig (webcamConfigValue defaultConfig)
                  ]

        OnConfiged _ ->
            ( picLoader, webcamAttach "#my-camera" )

        OnAttached _ ->
            ( { picLoader | webcamState = On }, Cmd.none )

        Snap ->
            ( { picLoader | webcamState = Off }, snap () )

        Snapped dataUri ->
            ( { picLoader | dataUri = Just dataUri }, Cmd.none )

        -- Case drop. Let the DnD library update it's model and emmit the loading effect
        DnD (Drop files) ->
            ( { picLoader
                | dnDModel = DragDrop.update (Drop files) picLoader.dnDModel
              }
            , loadFirstFile files
            )

        -- Other DnD cases. Let the DnD library update it's model.
        DnD a ->
            ( { picLoader
                | dnDModel = DragDrop.update a picLoader.dnDModel
              }
            , Cmd.none
            )

        FileData (Ok val) ->
            ( { picLoader | uploadDataUri = Just val }, Cmd.none ) |> Debug.log "val "

        FileData (Err err) ->
            { picLoader | imageLoadError = Just err } ! []


port webcamAttach : String -> Cmd msg


port webcamAttached : (() -> msg) -> Sub msg


port webcamConfig : WebcamConfigValue -> Cmd msg


port webcamConfiged : (() -> msg) -> Sub msg


port snap : () -> Cmd msg


port snapped : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ webcamAttached OnAttached
        , webcamConfiged OnConfiged
        , snapped Snapped
        ]


view : Model -> Maybe DataUri -> Html Msg
view picLoader dataUri =
    let
        empty =
            (picLoader.webcamState == Off && (dataUri == Nothing && picLoader.dataUri == Nothing))
    in
        div [ class "art-customer-pic" ]
            [ div [ styleWidthHeight, classList [ ( "empty", empty ) ] ]
                [ p [ classList [ ( "hidden", not empty ) ], class "help-text text-center" ] [ text "Press Camera to take a Photo or drop your file here. " ]
                  -- We attach webcam here. hidden if webcam is off
                , div
                    [ id "my-camera", classList [ ( "hidden", picLoader.webcamState == Off ) ] ]
                    []
                  -- Here is the img if available
                , div [ classList [ ( "hidden", picLoader.webcamState == On ) ] ]
                    [ picLoader.dataUri
                        |> Maybe.map (\uri -> img [ src uri, width <| .width defaultConfig, height <| .height defaultConfig ] [])
                        |> Maybe.withDefault (span [] [])
                    ]
                ]
              -- here is the buttons bar. if wecam is off the camera button is for Snap
            , div [ class "art-upload-shot" ]
                [ i
                    [ class "fa fa-2x fa-camera"
                    , onClick <|
                        if picLoader.webcamState == Off then
                            OnConfig
                        else
                            Snap
                    ]
                    []
                , i [ class "fa fa-2x fa-upload", classList [ ( "hidden", picLoader.webcamState == On ) ] ] []
                ]
            , viewUpload picLoader
            ]


styleWidthHeight =
    style
        [ ( "width", (toString <| .width defaultConfig) ++ "px" )
        , ( "height", (toString <| .height defaultConfig) ++ "px" )
        ]


viewUpload : Model -> Html Msg
viewUpload model =
    Html.map DnD <|
        div
            (countStyle model.dnDModel
                :: dragDropEventHandlers
            )
            [ renderImageOrPrompt model
            ]


renderImageOrPrompt : Model -> Html a
renderImageOrPrompt model =
    case model.imageLoadError of
        Just err ->
            text (FileReader.prettyPrint err)

        Nothing ->
            case model.uploadDataUri of
                Nothing ->
                    case model.dnDModel of
                        Normal ->
                            text "Drop stuff here"

                        Hovering ->
                            text "Gimmie!"

                Just result ->
                    img
                        [ property "src" result
                        , style [ ( "max-width", "100%" ) ]
                        ]
                        []


countStyle : DragDrop.HoverState -> Html.Attribute a
countStyle dragState =
    style
        [ ( "font-size", "20px" )
        , ( "font-family", "monospace" )
        , ( "display", "block" )
        , ( "width", "400px" )
        , ( "height", "200px" )
        , ( "text-align", "center" )
        , ( "background"
          , case dragState of
                DragDrop.Hovering ->
                    "#ffff99"

                DragDrop.Normal ->
                    "#cccc99"
          )
        ]



-- TASKS


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
