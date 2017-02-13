module Update exposing (update, subscriptions)

import Model exposing (Model)
import Messages exposing (Msg(..))
import Routing exposing (parseLocation)
import Shared.Login as Login
import LocalStorage
import Api


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange loc ->
            let
                newLoc =
                    parseLocation loc
            in
                ( { model | route = newLoc }, Cmd.none )

        LoginMsg msg_ ->
            let
                ( newLogin, cmd, jwt, email ) =
                    Login.update msg_ model.login

                context_ =
                    model.context

                context =
                    { context_ | jwt = jwt |> Maybe.map (\j -> Just j) |> Maybe.withDefault context_.jwt }

                cmds =
                    Cmd.batch
                        [ Cmd.map LoginMsg cmd
                        , jwt
                            |> Maybe.map (\j -> LocalStorage.setLocalStorage { key = "jwt", value = j })
                            |> Maybe.withDefault Cmd.none
                        , email
                            |> Maybe.map (\e -> Api.me e (jwt |> Maybe.withDefault "") OnMe)
                            |> Maybe.withDefault Cmd.none
                        ]
            in
                ( { model | login = newLogin, context = context }, cmds )

        OnMe (Ok me) ->
            let
                context_ =
                    model.context
            in
                ( { model | context = { context_ | me = me } }, Cmd.none )

        OnMe (Err err) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
