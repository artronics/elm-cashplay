module Home.Update exposing (update)

import Home.Models exposing (Home)
import Home.Messages exposing (Msg(..))
import Components.Login as Login


update : Msg -> Home -> ( Home, Cmd Msg )
update msg home =
    case msg of
        LoginMsg msg_ ->
            let
                ( newLogin, cmd ) =
                    Login.update msg_ home.login
            in
                ( { home | login = newLogin }, Cmd.map LoginMsg cmd )
