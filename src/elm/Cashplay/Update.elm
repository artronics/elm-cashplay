module Cashplay.Update exposing (update, subscriptions)

import Cashplay.Models exposing (Cashplay, Tab)
import Cashplay.Messages exposing (Msg(..))
import Customer.Update as CustomerTab
import Context exposing (Context)


update : Msg -> Cashplay -> Context -> ( Cashplay, Cmd Msg )
update msg cashplay context =
    case msg of
        SelectTab tab ->
            ( { cashplay | currentTab = tab }, Cmd.none )

        CustomerTabMsg msg_ ->
            let
                ( newCustomerTab, cmd ) =
                    CustomerTab.update msg_ cashplay.customerTab context
            in
                ( { cashplay | customerTab = newCustomerTab }, Cmd.map CustomerTabMsg cmd )


subscriptions : Cashplay -> Sub Msg
subscriptions cashplay =
    Sub.batch
        [ Sub.map CustomerTabMsg <| CustomerTab.subscriptions cashplay.customerTab ]
