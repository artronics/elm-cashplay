module Customer.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Customer.Model exposing (CustomerTab, View(..))
import Customer.Message exposing (Msg(..))
import Elements.Button as Btn exposing (btn)
import Elements.Icon as Icon exposing (icon)
import Customer.NewCustomer as NewCustomer


view : CustomerTab -> Html Msg
view customerTab =
    div [ class "row no-gutters" ]
        [ div [ class "col-md-2 art-section" ]
            [ viewNewCustomerBtn ]
        , div [ class "col art-bg art-section" ] [ viewMain customerTab ]
        , div [ class "col-md-3 art-section" ] [ text "bar" ]
        ]


viewNewCustomerBtn =
    div [ class "d-inline-flex w-100 justify-content-center" ]
        [ Btn.iconBtn [ class "btn-outline-primary", onClick <| ChangeView New ] "NEW CUSTOMER" "user-plus" ]


viewMain customerTab =
    case customerTab.currentView of
        Search ->
            div [] [ text "search" ]

        New ->
            Html.map NewCustomerMsg <| NewCustomer.view customerTab.newCustomer
