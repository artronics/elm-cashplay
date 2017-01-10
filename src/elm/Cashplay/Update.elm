module Cashplay.Update exposing (update)

import Material
import Cashplay.Models exposing (Cashplay)
import Cashplay.Messages exposing (Msg(..))
import Customer.Update as Customer


update : Msg -> Cashplay -> ( Cashplay, Cmd Msg )
update msg cashplay =
    case msg of
        SelectTab index ->
            ( { cashplay | currentTab = index }, Cmd.none )

        CustomerMsg msg_ ->
            let
                ( newCustomer, cmd ) =
                    Customer.update msg_ cashplay.customer
            in
                ( { cashplay | customer = newCustomer }, Cmd.map CustomerMsg cmd )

        Mdl msg_ ->
            Material.update Mdl msg_ cashplay
