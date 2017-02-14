module Cashplay.Update exposing (update)

import Cashplay.Model exposing (Cashplay)
import Cashplay.Message exposing (Msg(..))
import Context exposing (Context)
import Customer.Message as Customer
import Customer.Update as Customer


update : Msg -> Cashplay -> Context -> ( Cashplay, Cmd Msg )
update msg cashplay context =
    case msg of
        ChangeTab tab ->
            ( { cashplay | currentTab = tab }, Cmd.none )

        CustomerTabMsg msg_ ->
            updateCustomerTab msg_ cashplay context


updateCustomerTab : Customer.Msg -> Cashplay -> Context -> ( Cashplay, Cmd Msg )
updateCustomerTab msg cashplay context =
    let
        ( newCustomerTab, cmd ) =
            Customer.update msg cashplay.customerTab context
    in
        ( { cashplay | customerTab = newCustomerTab }, Cmd.map CustomerTabMsg cmd )
