module Home.Update exposing (update)

import Home.Models exposing (Home)
import Home.Messages exposing (Msg(..))
import Components.Login as Login
import Components.Signup as Signup


update : Msg -> Home -> ( Home, Cmd Msg )
update msg home =
    case msg of
        LoginMsg msg_ ->
            let
                ( newLogin, cmd ) =
                    Login.update msg_ home.login
            in
                ( { home | login = newLogin }, Cmd.map LoginMsg cmd )

        SignupMsg msg_ ->
            let
                ( newSignup, cmd ) =
                    Signup.update msg_ home.signup
            in
                ( { home | signup = newSignup }, Cmd.map SignupMsg cmd )
