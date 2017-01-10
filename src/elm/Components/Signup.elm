module Components.Signup exposing (..)

import Html exposing (Html, text, p)
import Http exposing (Response, Error(..))
import Navigation
import String
import Regex exposing (regex)
import Material
import Material.Options exposing (..)
import Material.Textfield as Textfield
import Material.Button as Button
import Api


type alias Signup =
    { firstName : String
    , lastName : String
    , email : String
    , password : String
    , passwordConfirm : String
    , company : String
    , matched : Bool
    , matchStarted : Bool
    , validateEmail : Bool
    , emailErr : String
    , netErr : String
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
    , validateEmail = False
    , emailErr = ""
    , netErr = ""
    , mdl = Material.model
    }


type Msg
    = Update (Signup -> String -> Signup) String
    | StartMatching
    | StartValEmail
    | OnSignup
    | OnLogin (Result Http.Error Api.JwtToken)
    | OnSignupRes (Result Http.Error Api.Signup)
    | Mdl (Material.Msg Msg)


update : Msg -> Signup -> ( Signup, Cmd Msg )
update msg signup =
    case msg of
        Update f input ->
            ( f signup input, Cmd.none )

        StartMatching ->
            ( { signup | matchStarted = True }, Cmd.none )

        StartValEmail ->
            ( { signup | validateEmail = True }, Cmd.none )

        OnSignup ->
            let
                batchCmd =
                    [ Api.login { email = signup.email, password = signup.password } OnLogin
                    , Api.signup
                        { firstName = signup.firstName
                        , lastName = signup.lastName
                        , company = signup.company
                        , email = signup.email
                        , password = signup.password
                        }
                        OnSignupRes
                    ]
            in
                ( signup, Cmd.batch batchCmd )

        OnSignupRes (Err err) ->
            let
                ( emailErr, netErr ) =
                    case err of
                        NetworkError ->
                            ( "", "No Internet Connection" )

                        BadStatus _ ->
                            ( "This email is already registered.", "" )

                        _ ->
                            ( "", "Network Error" )
            in
                ( { signup | emailErr = emailErr, netErr = netErr }, Cmd.none )

        OnSignupRes (Ok res) ->
            ( signup, Cmd.none )

        OnLogin (Ok jwt) ->
            ( signup, Navigation.newUrl "#cashplay" )

        OnLogin (Err err) ->
            ( { signup | netErr = "No Internet connection." }, Cmd.none )

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
              --            , onBlur StartValEmail
              --            , Textfield.error "Email has wrong format."
              --                |> when (matchEmail signup.email || signup.validateEmail)
              --            , Textfield.error signup.emailErr
              --                |> when (not <| String.isEmpty signup.emailErr)
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
            [ Button.raised
            , Button.primary
            , Button.ripple
            , onClick OnSignup
            ]
            [ text "Signup" ]
        ]


emailRx : String
emailRx =
    "\\S+@\\S+\\.\\S+"


matchEmail : String -> Bool
matchEmail email =
    email
        |> Regex.contains (regex emailRx)
