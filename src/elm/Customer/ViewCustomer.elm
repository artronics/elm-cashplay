module Customer.ViewCustomer exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, value)
import Customer.Customer exposing (Customer)
import Customer.Models exposing (CustomerTab)
import Customer.Messages exposing (Msg)
import Views.MessageBox as MsgBox
import Views.Elements.Textfield as Txt exposing (txt)


view : CustomerTab -> Html Msg
view customerTab =
    case customerTab.customerDetails of
        Just customer ->
            viewCustomer customerTab customer

        Nothing ->
            MsgBox.view "Can not find customer"


viewCustomer : CustomerTab -> Customer -> Html Msg
viewCustomer customerTab customer =
    div [ class "art-view-resource panel panel-default" ]
        [ div [ class "panel-heading" ]
            [ div [ class "clearfix" ]
                [ h3 [ class " panel-title pull-left" ] [ text <| customer.firstName ++ " " ++ customer.lastName ++ " [ " ++ toString (customer.id) ++ " ]" ]
                , i [ class "fa fa-lg fa-pencil pull-right" ] []
                , i [ class "fa fa-lg fa-trash pull-right" ] []
                ]
            ]
        , div [ class "panel-body" ]
            [ viewFields customerTab customer ]
        ]


viewFields : CustomerTab -> Customer -> Html Msg
viewFields customerTab customer =
    txt "First Name" [ value <| customer.firstName ] []
