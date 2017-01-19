module Customer.NewCustomer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onBlur)
import Customer.Customer exposing (..)
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab)
import Views.Elements.Textfield as Txt exposing (horInput)
import Views.Elements.Button as Btn exposing (btn)
import Views.Elements.Form as Frm exposing (frm)


view : CustomerTab -> Html Msg
view customerTab =
    div [ class "panel panel-default" ]
        [ div [ class "panel-heading" ]
            [ text "heading" ]
        , div [ class "panel-body" ]
            [ viewForm customerTab True
            ]
        , div [ class "panel-footer clearfix art-dialog-footer" ]
            [ btn [ class "pull-right", Btn.large, Btn.primary, onClick OnNewCustomerSave ] [ text "Save" ]
            , btn [ class "pull-right", Btn.large, Btn.default, onClick <| OnNewCustomerReset ] [ text "Reset" ]
            ]
        ]


viewForm : CustomerTab -> Bool -> Html Msg
viewForm customerTab asLabel =
    let
        newCustomer =
            customerTab.newCustomer

        customerValidation =
            customerTab.customerValidation
    in
        frm [ class "form-horizontal", Frm.editable <| not asLabel ]
            [ div [ class "col-md-3" ] [ customerPic ]
            , div [ class "col-md-9" ]
                [ horInput "First Name"
                    Txt.Full
                    customerValidation.firstName
                    [ onInput <| OnNewCustomerInput (\c i -> { c | firstName = i })
                    , onBlur <| OnCustomerValidation { customerValidation | firstName = valFirstName newCustomer }
                    , value newCustomer.firstName
                    , class "text-capitalize"
                    , disabled asLabel
                    ]
                , horInput "Last Name"
                    Txt.Full
                    customerValidation.lastName
                    [ onInput <| OnNewCustomerInput (\c i -> { c | lastName = i })
                    , onBlur <| OnCustomerValidation { customerValidation | lastName = valLastName newCustomer }
                    , value newCustomer.lastName
                    ]
                ]
            ]


customerPic : Html msg
customerPic =
    div [ class "art-customer-pic well" ]
        [ div [ class "art-upload-shot" ]
            [ i [ class "fa fa-2x fa-camera" ] []
            , i [ class "fa fa-2x fa-upload" ] []
            ]
        ]
