module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Navigation exposing (Location)
import Routing exposing (..)
import Messages exposing (Msg(..))
import Models exposing (..)
import Update exposing (..)
import View exposing (..)
import Api


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
        ( model currentRoute, initCmd )


initCmd : Cmd Msg
initCmd =
    Cmd.batch
        [ devLogin ]


devLogin : Cmd Msg
devLogin =
    Api.login { email = "dev@dev.com", password = "admin" } OnDevLogin



-- VIEW


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.none
        ]


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
