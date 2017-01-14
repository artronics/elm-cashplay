module Customer.NewCustomer exposing (..)

import Html exposing (Html, text, p)
import Customer.Customer exposing (Customer)
import Customer.Messages exposing (Msg(..))


view : Customer -> Html Msg
view customer =
    text "new custoemr"
