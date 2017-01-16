module Customer.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Customer.Models exposing (CustomerTab, View(..))
import Customer.Messages exposing (Msg(..))
import Customer.SearchBar as SearchBar exposing (view)
import Customer.ResultList as ResultList
import Views.Elements.Layout as Layout
import Views.Elements.Button as Btn
import Views.Elements.Label exposing (labelIcon)


view : CustomerTab -> Html Msg
view customerTab =
    div []
        [ div [ class "art-inline art-search-bar" ]
            [ SearchBar.view customerTab
            , Btn.btn
                [ Btn.default
                , style [ ( "margin-left", "100px" ) ]
                ]
                [ labelIcon "New Customer" "user-plus" ]
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
