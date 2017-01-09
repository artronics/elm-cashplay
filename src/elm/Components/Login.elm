module Components.Login exposing (..)

import Html exposing (Html, text, p)


type alias Login =
    { email : String
    , password : String
    }


loginInit : Login
loginInit =
    { email = ""
    , password = ""
    }


type Msg
    = UpEmail String
    | UpPass String
    | OnLogin


update : Msg -> Login -> ( Login, Cmd Msg )
update msg login =
    case msg of
        UpEmail email ->
            ( { login | email = email }, Cmd.none )

        UpPass pass ->
            ( { login | password = pass }, Cmd.none )

        OnLogin ->
            ( login, Cmd.none )


view : Login -> Html Msg
view login =
    text "login"
