module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model)
import Messages exposing (Msg(..))
import Shared.Login as Login
import Routing exposing (..)
import Cashplay.View as Cashplay


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ case model.route of
            Home ->
                div [] [ text "home page" ]

            Login ->
                Html.map LoginMsg <| Login.view model.login

            App ->
                Html.map CashplayMsg <| Cashplay.view model.cashplay

            NotFound ->
                div [] [ text "Not Found" ]
        ]
