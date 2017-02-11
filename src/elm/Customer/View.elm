module Customer.View exposing (view)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style)
import Customer.Models exposing (CustomerTab, View(..))
import Customer.Messages exposing (Msg(..))
import Customer.SearchBar as SearchBar exposing (view)
import Customer.ResultList as ResultList
import Views.Elements.Button as Btn
import Views.Elements.Label exposing (labelIcon)
import Views.Breadcrumb as Bread
import Views.MessageBox as MsgBox
import Customer.ViewOrEditOrNew as ViewEditNew
import Webcam


view : CustomerTab -> Html Msg
view customerTab =
    div []
        [ div [ class "art-inline art-search-bar" ]
            [ SearchBar.view customerTab
            , Btn.btn
                [ Btn.default
                , style [ ( "margin-left", "100px" ) ]
                , onClick OnNewCustomer
                ]
                [ labelIcon "New Customer" "user-plus" ]
            ]
        , Bread.view (createCrumb customerTab) SelectCrumb customerTab.currentView customerTab.breadInfo
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
                        let
                            title =
                                customerTab.customerDetails.firstName ++ " " ++ customerTab.customerDetails.lastName
                        in
                            ( "user", title, CustomerDetails )

                    NewCustomer ->
                        ( "user-plus", "New Customer", NewCustomer )

                    NetErr ->
                        ( "", "", NetErr )

                    None ->
                        ( "", "", None )
            )


viewContent : CustomerTab -> Html Msg
viewContent customerTab =
    case customerTab.currentView of
        SearchResults ->
            ResultList.view customerTab

        CustomerDetails ->
            ViewEditNew.view customerTab

        NewCustomer ->
            ViewEditNew.view customerTab

        NetErr ->
            MsgBox.view "Network err"

        None ->
            MsgBox.view "Use search. You can add customer to receipt or view customer details."
