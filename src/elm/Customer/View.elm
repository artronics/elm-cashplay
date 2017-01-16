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
import Views.Breadcrumb as Bread


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
        , Bread.view (createCrumb customerTab) SelectCrumb customerTab.currentView Bread.None
        , viewContent customerTab
        ]


createCrumb : CustomerTab -> List ( String, String, View )
createCrumb customerTab =
    customerTab.views
        |> List.map
            (\v ->
                case v of
                    SearchResults ->
                        ( "search", "Search Results", SearchResults )

                    CustomerDetails ->
                        ( "user", "customr details", CustomerDetails )

                    NetErr ->
                        ( "", "", NetErr )

                    None ->
                        ( "", "", None )
            )


viewContent : CustomerTab -> Html Msg
viewContent customerTab =
    case customerTab.currentView of
        SearchResults ->
            ResultList.view customerTab.fetchedCustomers

        _ ->
            text "unimplemented view"
