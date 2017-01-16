module Customer.View exposing (view)

import Html exposing (..)
import Customer.Models exposing (CustomerTab, View(..))
import Customer.Messages exposing (Msg(..))
import Customer.SearchBar as SearchBar exposing (view)
import Customer.ResultList as ResultList
import Views.Elements.Layout as Layout
import Views.Elements.Button as Btn


view : CustomerTab -> Html Msg
view customerTab =
    div []
        [ Layout.hbox []
            [ SearchBar.view customerTab
            , Btn.btn [ Btn.primary ] [ text "New Customer" ]
            ]
        , viewView customerTab
        ]


viewView : CustomerTab -> Html Msg
viewView customerTab =
    case customerTab.currentView of
        SearchResults customers ->
            ResultList.view customers

        _ ->
            text "unimplemented view"
