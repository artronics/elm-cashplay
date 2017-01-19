module Customer.ViewCustomer exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick)
import Customer.Customer exposing (Customer)
import Customer.Models exposing (CustomerTab)
import Customer.Messages exposing (Msg(..))
import Views.MessageBox as MsgBox
import Views.Elements.Textfield as Txt exposing (txt)
import Customer.EditOrNew as EditOrNew


view : CustomerTab -> Html Msg
view customerTab =
    let
        customer =
            customerTab.customerDetails
    in
        div [ class "art-view-resource panel panel-default" ]
            [ div [ class "panel-heading" ]
                [ div [ class "clearfix" ]
                    [ h3 [ class " panel-title pull-left" ] [ text <| customer.firstName ++ " " ++ customer.lastName ++ " [ " ++ toString (customer.id) ++ " ]" ]
                    , i [ class "fa fa-lg fa-pencil pull-right", onClick EditCustomer ] []
                    , i [ class "fa fa-lg fa-trash pull-right" ] []
                    ]
                ]
            , div [ class "panel-body" ]
                [ viewFields customerTab ]
            ]


viewFields : CustomerTab -> Html Msg
viewFields customerTab =
    EditOrNew.view customerTab
