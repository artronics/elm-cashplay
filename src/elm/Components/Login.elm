module Components.Login exposing (..)

import Html exposing (Html, text, p)
import Http exposing (Error(..))
import Navigation
import String
import Material
import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Typography as Typo
import Api as Api exposing (login)
import Debug


type alias Login =
    { email : String
    , password : String
    , msg : String
    , mdl : Material.Model
    }


initLogin : Login
initLogin =
    { email = ""
    , password = ""
    , msg = ""
    , mdl = Material.model
    }


type Msg
    = UpEmail String
    | UpPass String
    | OnLogin
    | OnLoginRes (Result Http.Error Api.JwtToken)
    | Mdl (Material.Msg Msg)


update : Msg -> Login -> ( Login, Cmd Msg, Maybe Api.JwtToken )
update msg login =
    case msg of
        UpEmail email ->
            ( { login | email = email }, Cmd.none, Nothing )

        UpPass pass ->
            ( { login | password = pass }, Cmd.none, Nothing )

        OnLogin ->
            ( { login | msg = "" }, Api.login { email = login.email, password = login.password } OnLoginRes, Nothing )

        OnLoginRes (Ok jwt) ->
            ( { login | msg = "" }, Navigation.newUrl "#cashplay", Just jwt )

        OnLoginRes (Err err) ->
            let
                errMsg =
                    case err of
                        BadStatus _ ->
                            "Invalid email or password"

                        NetworkError ->
                            "No Internet connection"

                        _ ->
                            "Network Error"
            in
                ( { login | msg = errMsg }, Cmd.none, Nothing )

        Mdl msg_ ->
            let
                ( m, c ) =
                    Material.update Mdl msg_ login
            in
                ( m, c, Nothing )


view : Login -> Html Msg
view login =
    div []
        [ Textfield.render Mdl
            [ 0 ]
            login.mdl
            [ Textfield.label "Email", onInput <| UpEmail ]
            []
        , Textfield.render Mdl
            [ 1 ]
            login.mdl
            [ Textfield.label "Password"
            , onInput <| UpPass
            , Textfield.error login.msg |> when (not <| String.isEmpty login.msg)
            ]
            []
        , Button.render Mdl
            [ 2 ]
            login.mdl
            [ Button.raised, Button.primary, onClick OnLogin ]
            [ text "Login" ]
        ]
