module Customer.View exposing (view)

import Html exposing (Html, text, p)
import Material.Options exposing (..)
import Customer.Models exposing (CustomerTab)
import Customer.Messages exposing (Msg(..))


view : CustomerTab -> Html Msg
view customer =
    text "customer module"
