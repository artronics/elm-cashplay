module Customer.View exposing (view)

import Html exposing (Html, text, p)
import Material.Options exposing (..)
import Customer.Models exposing (Customer)
import Customer.Messages exposing (Msg(..))


view : Customer -> Html Msg
view customer =
    text "customer module"
