module Customer.ViewOrEditOrNew exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Customer.Customer exposing (..)
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab, CustomerState(..))
import Views.Elements.Form as Frm exposing (frm)
import Views.Elements.Button as Btn exposing (btn)
import Views.Elements.Textfield as Txt exposing (horInput)


view : CustomerTab -> Html Msg
view customerTab =
    let
        ( asLabel, subject, viewHeader, viewFooter ) =
            case customerTab.customerState of
                New ->
                    ( False, customerTab.editOrNewCustomer, viewHeadingInNew, viewFooterInNew )

                Edit ->
                    ( False, customerTab.editOrNewCustomer, viewHeadingInEdit, viewFooterInEdit )

                Presentation ->
                    ( True, customerTab.customerDetails, viewHeadingInPresentation, viewFooterInPresentation )

        customerValidation =
            customerTab.customerValidation
    in
        div [ class "panel panel-default" ]
            [ div [ class "panel-heading" ] [ viewHeader subject ]
            , div [ class "panel-body" ]
                [ viewForm subject asLabel customerValidation
                ]
            , div [ class "panel-footer" ]
                [ viewFooter subject ]
            ]


viewHeadingInEdit : Customer -> Html Msg
viewHeadingInEdit subject =
    h5 [] [ text "Edit Customer" ]


viewFooterInEdit : Customer -> Html Msg
viewFooterInEdit subject =
    div [ class "clearfix art-dialog-footer" ]
        [ btn [ class "pull-right", Btn.large, Btn.primary, onClick OnEditCustomerSave ] [ text "Save" ]
        , btn [ class "pull-right", Btn.large, Btn.default, onClick <| OnEditCustomerCancel ] [ text "Cancel" ]
        ]


viewHeadingInNew : Customer -> Html Msg
viewHeadingInNew subject =
    text "heading in edit"


viewFooterInNew : Customer -> Html Msg
viewFooterInNew subject =
    div [ class "clearfix art-dialog-footer" ]
        [ btn [ class "pull-right", Btn.large, Btn.primary, onClick OnNewCustomerSave ] [ text "Save" ]
        , btn [ class "pull-right", Btn.large, Btn.default, onClick <| OnNewCustomerReset ] [ text "Reset" ]
        ]


viewHeadingInPresentation : Customer -> Html Msg
viewHeadingInPresentation subject =
    div [ class "clearfix" ]
        [ h3 [ class " panel-title pull-left" ] [ text <| subject.firstName ++ " " ++ subject.lastName ++ " [ " ++ toString (subject.id) ++ " ]" ]
        , i [ class "fa fa-lg fa-pencil pull-right", onClick EditCustomer ] []
        , i [ class "fa fa-lg fa-trash pull-right" ] []
        ]


viewFooterInPresentation : Customer -> Html Msg
viewFooterInPresentation subject =
    span [] []


viewForm : Customer -> Bool -> CustomerValidation -> Html Msg
viewForm subject asLabel customerValidation =
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
