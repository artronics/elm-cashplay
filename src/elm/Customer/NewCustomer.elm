module Customer.NewCustomer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onBlur)
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab)
import Views.Elements.Button as Btn exposing (btn)
import Customer.EditOrNew as EditOrNew


view : CustomerTab -> Html Msg
view customerTab =
    div [ class "panel panel-default" ]
        [ div [ class "panel-heading" ]
            [ text "heading" ]
        , div [ class "panel-body" ]
            [ EditOrNew.view customerTab
            ]
        , div [ class "panel-footer clearfix art-dialog-footer" ]
            [ btn [ class "pull-right", Btn.large, Btn.primary, onClick OnNewCustomerSave ] [ text "Save" ]
            , btn [ class "pull-right", Btn.large, Btn.default, onClick <| OnNewCustomerReset ] [ text "Reset" ]
            ]
        ]
