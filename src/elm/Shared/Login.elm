module Shared.Login exposing (Model, init, Msg, update, view)

import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Navigation
import Elements.Button as Btn exposing (btn)
import Elements.Input as Inp exposing (inp)
import Api exposing (login)


type alias Model =
    { email : String
    , password : String
    , msg : String
    }


init : Model
init =
    { email = ""
    , password = ""
    , msg = ""
    }


type Msg
    = Email String
    | Password String
    | Login
    | OnLogin (Result Http.Error Api.JwtToken)


update : Msg -> Model -> ( Model, Cmd Msg, Maybe String, Maybe String )
update msg model =
    case msg of
        Email email ->
            ( { model | email = email }, Cmd.none, Nothing, Nothing )

        Password pass ->
            ( { model | password = pass }, Cmd.none, Nothing, Nothing )

        Login ->
            ( model, login { email = model.email, password = model.password } OnLogin, Nothing, Nothing )

        OnLogin (Ok jwt) ->
            ( model, Navigation.newUrl "#app", Just jwt.jwt, Just model.email )

        OnLogin (Err err) ->
            ( { model | msg = toString err }, Cmd.none, Nothing, Nothing )


view : Model -> Html Msg
view model =
    Html.form []
        [ inp [ Inp.email, onInput Email ] "Email" ""
        , inp [ Inp.password, onInput Password ] "Password" model.msg
        , btn
            [ Btn.primary
            , Btn.large
            , onClick Login
            , disabled (model.email == "" || model.password == "")
            ]
            [ text "Login" ]
        ]
