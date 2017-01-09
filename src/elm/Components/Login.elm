module Components.Login exposing (..)

import Html exposing (Html, text, p)
import Http exposing (Error(..))
import String
import Material
import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Typography as Typo
import Api as Api exposing (login)


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


update : Msg -> Login -> ( Login, Cmd Msg )
update msg login =
    case msg of
        UpEmail email ->
            ( { login | email = email }, Cmd.none )

        UpPass pass ->
            ( { login | password = pass }, Cmd.none )

        OnLogin ->
            ( { login | msg = "" }, Api.login { email = login.email, password = login.password } OnLoginRes )

        OnLoginRes (Ok _) ->
            ( login, Cmd.none )

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
                ( { login | msg = errMsg }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ login


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
