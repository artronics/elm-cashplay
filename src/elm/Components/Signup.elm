module Components.Signup exposing (..)

import Html exposing (Html, text, p)
import Material
import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Button as Button


type alias Signup =
    { firstName : String
    , lastName : String
    , email : String
    , password : String
    , passwordConfirm : String
    , company : String
    , matched : Bool
    , matchStarted : Bool
    , mdl : Material.Model
    }


initSignup : Signup
initSignup =
    { firstName = ""
    , lastName = ""
    , email = ""
    , password = ""
    , passwordConfirm = ""
    , company = ""
    , matched = True
    , matchStarted = False
    , mdl = Material.model
    }


type Msg
    = Update (Signup -> String -> Signup) String
    | StartMatching
    | Mdl (Material.Msg Msg)


update : Msg -> Signup -> ( Signup, Cmd Msg )
update msg signup =
    case msg of
        Update f input ->
            ( f signup input, Cmd.none )

        StartMatching ->
            ( { signup | matchStarted = True }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ signup


view : Signup -> Html Msg
view signup =
    div []
        [ Textfield.render Mdl
            [ 0 ]
            signup.mdl
            [ Textfield.label "First Name"
            , onInput <| Update (\m s -> { m | firstName = s })
            ]
            []
        , Textfield.render Mdl
            [ 1 ]
            signup.mdl
            [ Textfield.label "Last Name"
            , onInput <| Update (\m s -> { m | lastName = s })
            ]
            []
        , Textfield.render Mdl
            [ 2 ]
            signup.mdl
            [ Textfield.label "Email"
            , onInput <| Update (\m s -> { m | email = s })
            ]
            []
        , Textfield.render Mdl
            [ 3 ]
            signup.mdl
            [ Textfield.label "Company"
            , onInput <| Update (\m s -> { m | company = s })
            ]
            []
        , Textfield.render Mdl
            [ 4 ]
            signup.mdl
            [ Textfield.label "Password"
            , onInput <| Update (\m s -> { m | password = s })
            ]
            []
        , Textfield.render Mdl
            [ 5 ]
            signup.mdl
            [ Textfield.label "Confirm Password"
            , onInput <| Update (\m s -> { m | passwordConfirm = s })
            , onFocus StartMatching
            , Textfield.error "Password doesn't match."
                |> when (signup.password /= signup.passwordConfirm && signup.matchStarted)
            ]
            []
        , Button.render Mdl
            [ 6 ]
            signup.mdl
            [ Button.raised, Button.primary, Button.ripple ]
            [ text "Signup" ]
        ]
