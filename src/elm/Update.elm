module Update exposing (update, subscriptions)

import Model exposing (Model)
import Messages exposing (Msg(..))
import Routing exposing (parseLocation)
import Shared.Login as Login
import LocalStorage


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
                ( newLogin, cmd, jwt ) =
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
                        ]
            in
                ( { model | login = newLogin, context = context }, cmds )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
