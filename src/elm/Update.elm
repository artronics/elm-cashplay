module Update exposing (update, subscriptions)

import Navigation
import Model exposing (Model)
import Messages exposing (Msg(..))
import Routing exposing (parseLocation)
import Shared.Login as Login
import LocalStorage
import Api
import Cashplay.Update as Cashplay
import Cashplay.Message as Cashplay


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CashplayMsg msg_ ->
            updateCashplay msg_ model

        OnLocationChange loc ->
            let
                newLoc =
                    parseLocation loc
            in
                ( { model | route = newLoc }, Cmd.none )

        LoginMsg msg_ ->
            let
                ( newLogin, cmd, jwt ) =
                    Login.update msg_ model.login

                context_ =
                    model.context

                context =
                    { context_ | jwt = jwt |> Maybe.map (\j -> Just j) |> Maybe.withDefault context_.jwt }

                cmds =
                    jwt
                        |> Maybe.map
                            (\j ->
                                Cmd.batch
                                    [ Cmd.map LoginMsg cmd
                                    , LocalStorage.setLocalStorage { key = "jwt", value = j }
                                    , Api.me j OnMe
                                    ]
                            )
                        |> Maybe.withDefault (Cmd.map LoginMsg cmd)
            in
                ( { model | login = newLogin, context = context }, cmds )

        OnMe (Ok me) ->
            let
                context_ =
                    model.context
            in
                ( { model | context = { context_ | me = me } }, Navigation.newUrl "#app" )

        OnMe (Err err) ->
            ( model, Navigation.newUrl "#login" )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


updateCashplay : Cashplay.Msg -> Model -> ( Model, Cmd Msg )
updateCashplay msg model =
    let
        ( newCashplay, cmd ) =
            Cashplay.update msg model.cashplay model.context
    in
        ( { model | cashplay = newCashplay }, Cmd.map CashplayMsg cmd )
