module Main exposing (..)

import Navigation exposing (Location)
import Model exposing (Model, init)
import Messages exposing (Msg(..))
import View exposing (view)
import Update exposing (update, subscriptions)
import Routing exposing (parseLocation)


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

        context =
            { context_ | jwt = jwt }

        model =
            { initModel | context = context }
    in
        ( model, initCmd )


initCmd : Cmd Msg
initCmd =
    Cmd.batch
        [ Cmd.none ]


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
