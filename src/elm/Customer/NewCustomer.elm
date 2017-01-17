module Customer.NewCustomer exposing (..)

import Html exposing (Html, text, p)
import Customer.Customer exposing (Customer)
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab)


view : CustomerTab -> Html Msg
view customerTab =
    text "new custoemrsd"
