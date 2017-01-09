module Main exposing (..)

import Html exposing (Html, p, text)
import Navigation exposing (Location)
import Material.Options exposing (..)
import Routing exposing (..)
import Home.Messages as HomePage
import Home.View as HomePage
import Home.Update as HomePage
import Home.Models as HomePage


type alias Model =
    { route : Route
    , home : HomePage.Home
    }


model : Route -> Model
model route =
    { route = route
    , home = HomePage.init
    }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
        ( model currentRoute, Cmd.none )


type Msg
    = OnLocationChange Location
    | HomeMsg HomePage.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange loc ->
            let
                newLoc =
                    parseLocation loc
            in
                ( { model | route = newLoc }, Cmd.none )

        HomeMsg msg_ ->
            let
                ( newHome, cmd ) =
                    HomePage.update msg_ model.home
            in
                ( { model | home = newHome }, Cmd.map HomeMsg cmd )



-- VIEW


view : Model -> Html.Html Msg
view model =
    div [ cs "art-container" ]
        [ div [ cs "art-header" ] [ p [] [ text "Cashplay" ] ]
        , div [ cs "art-main-row" ]
            [ div [ cs "art-actions" ] [ p [] [ text "Actions" ] ]
            , div [ cs "art-tabs" ]
                [ page model ]
            , div [ cs "art-receipt" ] [ p [] [ text "Receipt" ] ]
            ]
        ]


page : Model -> Html Msg
page model =
    case model.route of
        Home ->
            Html.map HomeMsg <| HomePage.view model.home

        Cashplay ->
            text "cashplay"

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
