module Main exposing (..)

import Navigation exposing (Location)
import Model exposing (Model, init)
import Messages exposing (Msg(..))
import View exposing (view)
import Update exposing (update, subscriptions)
import Routing exposing (parseLocation)
import Api


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            parseLocation location

        jwt =
            if flags.jwt == "" then
                Nothing
            else
                Just flags.jwt

        initModel =
            Model.init currentRoute

        context_ =
            initModel.context

        model =
            { initModel | context = { context_ | jwt = jwt } }
    in
        ( model, initCmd jwt )


initCmd : Maybe String -> Cmd Msg
initCmd token =
    let
        cmd =
            token |> Maybe.map (\t -> Api.me t OnMe) |> Maybe.withDefault Cmd.none
    in
        Cmd.batch
            [ cmd ]


type alias Flags =
    { jwt : String
    }


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
