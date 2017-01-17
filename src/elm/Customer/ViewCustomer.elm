module Customer.ViewCustomer exposing (view)

import Html exposing (..)
import Customer.Customer exposing (Customer)
import Customer.Models exposing (CustomerTab)
import Customer.Messages exposing (Msg)
import Views.MessageBox as MsgBox


view : CustomerTab -> Html Msg
view customerTab =
    case customerTab.customerDetails of
        Just customer ->
            viewCustomer customer

        Nothing ->
            MsgBox.view "Can not find customer"


viewCustomer : Customer -> Html Msg
viewCustomer customer =
    text <| toString customer
