module Update exposing (..)

import Navigation exposing (Location)
import Messages exposing (..)
import Models exposing (..)
import Routing exposing (..)
import Home.Update as HomePage
import Cashplay.Update as Cashplay


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnDevLogin (Ok jwt) ->
            ( { model | login = True, jwt = jwt.token }, Navigation.newUrl "#cashplay" )

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
