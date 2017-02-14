module Customer.View exposing (view)

import Html exposing (..)
import Customer.Model exposing (CustomerTab)
import Customer.Message exposing (Msg(..))


view : CustomerTab -> Html Msg
view customerTab =
    div [] [ text "customer tab" ]
