module Customer.NewCustomer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onBlur)
import Customer.Customer exposing (..)
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab)
import Views.Elements.Textfield as Txt exposing (txt)
import Views.Elements.Button as Btn exposing (btn)


view : CustomerTab -> Html Msg
view customerTab =
    div [ class "panel panel-default" ]
        [ div [ class "panel-heading" ]
            [ text "heading" ]
        , div [ class "panel-body" ]
            [ viewForm customerTab
            ]
        , div [ class "panel-footer clearfix art-dialog-footer" ]
            [ btn [ class "pull-right", Btn.large, Btn.primary ] [ text "Save" ]
            , btn [ class "pull-right", Btn.large, Btn.default, onClick <| OnNewCustomerReset ] [ text "Reset" ]
            ]
        ]


viewForm : CustomerTab -> Html Msg
viewForm customerTab =
    let
        newCustomer =
            customerTab.newCustomer

        customerValidation =
            customerTab.customerValidation
    in
        Html.form [ class "form-horizontal" ]
            [ div [ class "col-md-3" ] [ customerPic ]
            , div [ class "col-md-9" ]
                [ horInput "First Name"
                    Full
                    customerValidation.firstName
                    [ onInput <| OnNewCustomerInput (\c i -> { c | firstName = i })
                    , onBlur <| OnCustomerValidation { customerValidation | firstName = valFirstName newCustomer }
                    , value customerTab.newCustomer.firstName
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


type Width
    = Full
    | Half


horInput : String -> Width -> Maybe String -> List (Attribute msg) -> Html msg
horInput lbl width valMsg atr =
    div
        [ class "form-group col-sm-12"
        , class <|
            if width == Full then
                "col-md-12"
            else
                "col-md-6"
        , class
            (valMsg
                |> Maybe.map (\_ -> "has-error")
                |> Maybe.withDefault ""
            )
        ]
        [ label [ class "col-sm-3 control-label" ] [ text <| lbl ++ ":" ]
        , div [ class "col-sm-9" ]
            [ input
                ([ class "form-control text-capitalize"
                 , placeholder lbl
                 ]
                    ++ atr
                )
                []
            , span [ class "help-block" ]
                [ text
                    (valMsg
                        |> Maybe.withDefault ""
                    )
                ]
            ]
        ]
