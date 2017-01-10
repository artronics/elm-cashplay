module Cashplay.Update exposing (update)

import Material
import Cashplay.Models exposing (Cashplay)
import Cashplay.Messages exposing (Msg(..))
import Customer.Update as CustomerTab


update : Msg -> Cashplay -> ( Cashplay, Cmd Msg )
update msg cashplay =
    case msg of
        SelectTab index ->
            ( { cashplay | currentTab = index }, Cmd.none )

        CustomerTabMsg msg_ ->
            let
                ( newCustomerTab, cmd ) =
                    CustomerTab.update msg_ cashplay.customerTab
            in
                ( { cashplay | customerTab = newCustomerTab }, Cmd.map CustomerTabMsg cmd )

        Mdl msg_ ->
            Material.update Mdl msg_ cashplay
