module Customer.ResultList exposing (..)

import Html exposing (Html, text, p)
import Customer.Models exposing (CustomerTab)
import Customer.Messages exposing (Msg(..))
import Customer.Customer exposing (Customer)


view : List Customer -> Html Msg
view customers =
    text "customer table"
