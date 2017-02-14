module Customer.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Customer.Model exposing (CustomerTab)
import Customer.Message exposing (Msg(..))
import Elements.Button as Btn exposing (btn)
import Elements.Icon as Icon exposing (icon)


view : CustomerTab -> Html Msg
view customerTab =
    div [ class "row no-gutters" ]
        [ div [ class "col-md-2 art-section" ]
            [ viewNewCustomerBtn ]
        , div [ class "col art-bg art-section" ] [ text "foo" ]
        , div [ class "col-md-3 art-section" ] [ text "bar" ]
        ]


viewNewCustomerBtn =
    div [ class "d-inline-flex w-100 justify-content-center" ]
        [ Btn.iconBtn [ class "btn-outline-primary" ] "NEW CUSTOMER" "user-plus" ]
