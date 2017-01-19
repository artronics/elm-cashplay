module Customer.EditOrNew exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Customer.Customer exposing (..)
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab, CustomerState(..))
import Views.Elements.Form as Frm exposing (frm)
import Views.Elements.Textfield as Txt exposing (horInput)


view : CustomerTab -> Html Msg
view customerTab =
    let
        ( asLabel, subject ) =
            case customerTab.customerState of
                New ->
                    ( False, customerTab.editOrNewCustomer )

                Edit ->
                    ( False, customerTab.editOrNewCustomer )

                Presentation ->
                    ( True, customerTab.customerDetails )

        customerValidation =
            customerTab.customerValidation
    in
        frm [ class "form-horizontal", Frm.editable <| not asLabel ]
            [ div [ class "col-md-3" ] [ customerPic ]
            , div [ class "col-md-9" ]
                [ horInput "First Name"
                    Txt.Full
                    customerValidation.firstName
                    [ onInput <| OnEditOrNewCustomerInput (\c i -> { c | firstName = i })
                    , onBlur <| OnCustomerValidation { customerValidation | firstName = valFirstName subject }
                    , value subject.firstName
                    , class "text-capitalize"
                    , disabled asLabel
                    ]
                , horInput "Last Name"
                    Txt.Full
                    customerValidation.lastName
                    [ onInput <| OnEditOrNewCustomerInput (\c i -> { c | lastName = i })
                    , onBlur <| OnCustomerValidation { customerValidation | lastName = valLastName subject }
                    , value subject.lastName
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
