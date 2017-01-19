module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)
import Messages exposing (..)
import Routing exposing (..)
import Home.View as HomePage
import Cashplay.View as Cashplay


view : Model -> Html.Html Msg
view model =
    div [ class "art-container" ]
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        Home ->
            Html.map HomeMsg <| HomePage.view model.home

        Cashplay ->
            Html.map CashplayMsg <| Cashplay.view model.cashplay

        NotFound ->
            text "page not found"
