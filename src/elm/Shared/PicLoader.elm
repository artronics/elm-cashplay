port module Shared.PicLoader exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Debug


type alias DataUri =
    String


type WebcamState
    = Off
    | On


type alias Model =
    { dataUri : Maybe DataUri
    , webcamState : WebcamState
    }


init : Model
init =
    { dataUri = Nothing
    , webcamState = Off
    }


type Msg
    = OnConfig
    | OnAttached ()
    | OnConfiged ()
    | Snap
    | Snapped DataUri


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
            ]


styleWidthHeight =
    style
        [ ( "width", (toString <| .width defaultConfig) ++ "px" )
        , ( "height", (toString <| .height defaultConfig) ++ "px" )
        ]
