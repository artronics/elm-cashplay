module Components.Login exposing (..)

import Html exposing (Html, p, text)
import Material
import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Button as Button


type alias Model =
    { email : String
    , password : String
    , mdl : Material.Model
    }


init : Model
init =
    { email = ""
    , password = ""
    , mdl = Material.model
    }


type Msg
    = Login
    | UpEmail String
    | UpPass String
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login ->
            ( model, Cmd.none )

        UpEmail email ->
            ( { model | email = email }, Cmd.none )

        UpPass pass ->
            ( { model | password = pass }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
    div []
        [ Textfield.render Mdl
            [ 0 ]
            model.mdl
            [ Textfield.label "Email", onInput <| UpEmail ]
            []
        , Textfield.render Mdl
            [ 1 ]
            model.mdl
            [ Textfield.label "Password", onInput <| UpPass ]
            []
        , Button.render Mdl
            [ 2 ]
            model.mdl
            [ Button.raised, Button.primary, onClick Login ]
            [ text "Login" ]
        ]
