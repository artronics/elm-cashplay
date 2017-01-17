module Customer.NewCustomer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (placeholder, class)
import Html.Events exposing (onInput)
import Customer.Customer exposing (Customer)
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab)


view : CustomerTab -> Html Msg
view customerTab =
    div [ class "panel panel-default" ]
        [ div [ class "panel-heading" ]
            [ text "heading" ]
        , div [ class "panel-body" ]
            [ viewForm customerTab
            ]
        ]


viewForm : CustomerTab -> Html Msg
viewForm customerTab =
    form [ class "form-horizontal" ]
        [ div [ class "row" ]
            [ halfInput "First Name" (\c i -> { c | firstName = i })
            , halfInput "Last Name" (\c i -> { c | lastName = i })
            ]
        ]


halfInput : String -> (Customer -> String -> Customer) -> Html Msg
halfInput lbl update =
    div [ class "form-group col-sm-12 col-md-6" ]
        [ label [ class "col-sm-3 control-label" ] [ text <| lbl ++ ":" ]
        , div [ class "col-sm-9" ]
            [ input
                [ class "form-control"
                , placeholder lbl
                , onInput <| OnNewCustomerInput update
                ]
                []
            ]
        ]
