module Customer.View exposing (view)

import Html exposing (Html, text, p)
import Material.Options exposing (..)
import Customer.Models exposing (CustomerTab, View(..))
import Customer.Messages exposing (Msg(..))
import Customer.SearchBar as SearchBar exposing (view)
import Customer.ResultList as ResultList


view : CustomerTab -> Html Msg
view customerTab =
    div []
        [ SearchBar.view customerTab
        , viewView customerTab
        ]


viewView : CustomerTab -> Html Msg
viewView customerTab =
    case customerTab.currentView of
        SearchResults customers ->
            ResultList.view customers

        _ ->
            text "unimplemented view"
