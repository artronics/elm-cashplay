module Main exposing (..)

import Html exposing (Html, p, text)
import Http
import Navigation exposing (Location)
import Material.Options exposing (..)
import Routing exposing (..)
import Home.Messages as HomePage
import Home.View as HomePage
import Home.Update as HomePage
import Home.Models as HomePage
import Cashplay.Messages as Cashplay
import Cashplay.View as Cashplay
import Cashplay.Models as Cashplay
import Cashplay.Update as Cashplay
import Api


type alias Model =
    { login : Bool
    , route : Route
    , home : HomePage.Home
    , cashplay : Cashplay.Cashplay
    }


model : Route -> Model
model route =
    { login = False
    , route = route
    , home = HomePage.init
    , cashplay = Cashplay.init
    }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
        ( model currentRoute, initCmd )


type Msg
    = OnLocationChange Location
    | HomeMsg HomePage.Msg
    | CashplayMsg Cashplay.Msg
      -- When we start app in dev mode, we send a login req to the server.
      -- Server in dev mode is seeded with given user.
      -- This is required because server will store current user email in server settings
      -- which will be used for subsequents queries
      --TODO delete auto login in production
    | OnDevLogin (Result Http.Error Api.JwtToken)


devLogin : Cmd Msg
devLogin =
    Api.login { email = "dev@dev.com", password = "admin" } OnDevLogin


initCmd : Cmd Msg
initCmd =
    Cmd.batch
        [ devLogin ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnDevLogin (Ok jwt) ->
            ( { model | login = True }, Navigation.newUrl "#cashplay" )

        OnDevLogin (Err _) ->
            ( model, Cmd.none )

        OnLocationChange loc ->
            let
                newLoc =
                    parseLocation loc
            in
                ( { model | route = newLoc }, Cmd.none )

        HomeMsg msg_ ->
            let
                ( newHome, cmd, jwt ) =
                    HomePage.update msg_ model.home
            in
                ( { model | home = newHome }, Cmd.map HomeMsg cmd )

        CashplayMsg msg_ ->
            let
                ( newCashplay, cmd ) =
                    Cashplay.update msg_ model.cashplay
            in
                ( { model | cashplay = newCashplay }, Cmd.map CashplayMsg cmd )



-- VIEW


view : Model -> Html.Html Msg
view model =
    div [ cs "art-container" ]
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        Home ->
            Html.map HomeMsg <| HomePage.view model.home

        Cashplay ->
            Html.map CashplayMsg <| Cashplay.view model.cashplay

        NotFound ->
            text "page not found"


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.none
        ]


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
