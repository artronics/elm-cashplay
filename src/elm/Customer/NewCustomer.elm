module Customer.NewCustomer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Customer.Customer exposing (Customer)
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab)
import Views.Elements.Textfield as Txt exposing (txt)


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
    Html.form [ class "form-horizontal" ]
        [ div [ class "col-md-3" ] [ customerPic ]
        , div [ class "col-md-9" ]
            [ horInput "First Name" Full (OnNewCustomerInput (\c i -> { c | firstName = i }))
            , horInput "Last Name" Full (OnNewCustomerInput (\c i -> { c | lastName = i }))
            , horInput "Last Name" Full (OnNewCustomerInput (\c i -> { c | lastName = i }))
            , horInput "Last Name" Full (OnNewCustomerInput (\c i -> { c | lastName = i }))
              --            , txt "FirstName" [ onInput <| OnNewCustomerInput (\c i -> { c | firstName = i }) ] []
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


horInput : String -> Width -> (String -> msg) -> Html msg
horInput lbl width msg =
    div
        [ class "form-group col-sm-12"
        , class <|
            if width == Full then
                "col-md-12"
            else
                "col-md-6"
        ]
        [ label [ class "col-sm-3 control-label" ] [ text <| lbl ++ ":" ]
        , div [ class "col-sm-9" ]
            [ input
                [ class "form-control"
                , placeholder lbl
                , onInput <| msg
                ]
                []
            ]
        ]
