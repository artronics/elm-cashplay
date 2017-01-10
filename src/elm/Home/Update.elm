module Home.Update exposing (update)

import Home.Models exposing (Home)
import Home.Messages exposing (Msg(..))
import Components.Login as Login
import Components.Signup as Signup
import Api


update : Msg -> Home -> ( Home, Cmd Msg, Maybe Api.JwtToken )
update msg home =
    case msg of
        LoginMsg msg_ ->
            let
                ( newLogin, cmd, jwt ) =
                    Login.update msg_ home.login
            in
                ( { home | login = newLogin }, Cmd.map LoginMsg cmd, jwt )

        SignupMsg msg_ ->
            let
                ( newSignup, cmd ) =
                    Signup.update msg_ home.signup
            in
                ( { home | signup = newSignup }, Cmd.map SignupMsg cmd, Nothing )
