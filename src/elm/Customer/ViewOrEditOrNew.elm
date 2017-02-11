module Customer.ViewOrEditOrNew exposing (view)

import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Customer.Customer exposing (..)
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab, CustomerState(..))
import Shared.PicLoader as PicLoader
import Shared.PicListLoader as PicListLoader
import Shared.ImgInput as ImgInput
import Views.Elements.Form as Frm exposing (frm)
import Views.Elements.Button as Btn exposing (btn)
import Views.Elements.Textfield as Txt exposing (horInput)
import Views.ImgBox as ImgBox


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
        div [ class "panel panel-default art-view-edit-new" ]
            [ div [ class "panel-heading" ] [ viewHeader subject ]
            , div [ class "panel-body" ]
                [ viewForm customerTab subject asLabel customerValidation
                ]
            , div [ class "panel-footer" ]
                [ viewFooter subject ]
            ]


viewHeadingInEdit : Customer -> Html Msg
viewHeadingInEdit subject =
    h3 [ class "panel-title" ] [ text "Edit Customer" ]


viewFooterInEdit : Customer -> Html Msg
viewFooterInEdit subject =
    div [ class "clearfix art-dialog-footer" ]
        [ btn [ class "pull-right", Btn.large, Btn.primary, onClick OnEditCustomerSave ] [ text "Save" ]
        , btn [ class "pull-right", Btn.large, Btn.default, onClick <| OnEditCustomerCancel ] [ text "Cancel" ]
        ]


viewHeadingInNew : Customer -> Html Msg
viewHeadingInNew subject =
    h3 [ class "panel-title" ] [ text "New Customer" ]


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


viewForm : CustomerTab -> Customer -> Bool -> CustomerValidation -> Html Msg
viewForm customerTab subject asLabel customerValidation =
    frm [ class "form-horizontal", Frm.editable <| not asLabel ]
        [ div [ class "col-md-3" ] [ customerPic customerTab subject ]
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
                , class "text-capitalize"
                , disabled asLabel
                ]
            ]
        , div [ class "col-md-12" ]
            [ customerDocs customerTab subject ]
        ]


customerPic : CustomerTab -> Customer -> Html Msg
customerPic customerTab subject =
    let
        hasPic =
            if String.isEmpty subject.pic then
                Nothing
            else
                Just subject.pic
    in
        case customerTab.customerState of
            Presentation ->
                ImgBox.viewImgBox subject.pic (subject.firstName ++ " " ++ subject.lastName) NoOp

            _ ->
                div []
                    [ Html.map ImgInputMsg <| ImgInput.view customerTab.imgInput hasPic
                    , span [ class "error" ] [ text (customerTab.customerValidation.pic |> Maybe.withDefault "") ]
                    ]


customerDocs : CustomerTab -> Customer -> Html Msg
customerDocs customerTab subject =
    --    Html.map PicListLoaderMsg <| PicListLoader.view customerTab.picListLoader (Just [])
    text "cus docs"
