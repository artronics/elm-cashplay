module Cashplay.Update exposing (update)

import Cashplay.Models exposing (Cashplay, Tab)
import Cashplay.Messages exposing (Msg(..))
import Customer.Update as CustomerTab


update : Msg -> Cashplay -> ( Cashplay, Cmd Msg )
update msg cashplay =
    case msg of
        SelectTab tab ->
            ( { cashplay | currentTab = tab }, Cmd.none )

        CustomerTabMsg msg_ ->
            let
                ( newCustomerTab, cmd ) =
                    CustomerTab.update msg_ cashplay.customerTab
            in
                ( { cashplay | customerTab = newCustomerTab }, Cmd.map CustomerTabMsg cmd )
