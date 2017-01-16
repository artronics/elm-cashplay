module Customer.ResultList exposing (..)

import Html exposing (Html, text, p)
import Html.Events exposing (onClick)
import Customer.Models exposing (CustomerTab)
import Customer.Messages exposing (Msg(..))
import Customer.Customer exposing (Customer)


view : List Customer -> Html Msg
view customers =
    p [ onClick <| OnCustomerDetails fakeCus ] [ text "this is a customer list" ]


fakeCus =
    { id = 1, firstName = "jalal", lastName = "hos" }
