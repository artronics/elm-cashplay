module Update exposing (update, subscriptions)

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
            let
                context_ =
                    model.context

                context =
                    { context_ | jwt = jwt }
            in
                ( { model | login = True, context = context }, Navigation.newUrl "#cashplay" )

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
                    Cashplay.update msg_ model.cashplay model.context
            in
                ( { model | cashplay = newCashplay }, Cmd.map CashplayMsg cmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map CashplayMsg <| Cashplay.subscriptions model.cashplay ]
