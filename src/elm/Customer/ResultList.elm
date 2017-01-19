module Customer.ResultList exposing (..)

import Html exposing (..)
import Dict as Dict exposing (Dict)
import Customer.Models exposing (CustomerTab, View(..))
import Customer.Messages exposing (Msg(..))
import Customer.Customer exposing (Customer, customersToDict)
import Shared.ViewReceipt as ViewReceipt
import Debug


update : ViewReceipt.Msg -> CustomerTab -> ( CustomerTab, Cmd Msg )
update msg customerTab =
    let
        getRes =
            \key ->
                customersToDict customerTab.fetchedCustomers
                    |> Dict.get key

        ( newViewReceipt, ( viewCustomer, _ ) ) =
            ViewReceipt.update msg customerTab.viewReceipt getRes

        ( views, currentView, customerDetails ) =
            viewCustomer
                |> Maybe.map
                    (\c ->
                        ( [ SearchResults, CustomerDetails ], CustomerDetails, viewCustomer )
                    )
                |> Maybe.withDefault ( customerTab.views, customerTab.currentView, customerTab.customerDetails )
    in
        ( { customerTab
            | viewReceipt = newViewReceipt
            , customerDetails = customerDetails
            , views = views
            , currentView = currentView
          }
        , Cmd.none
        )


view : CustomerTab -> Html Msg
view customerTab =
    Html.map ViewReceiptMsg <|
        ViewReceipt.view customerTab.viewReceipt
            tableHeaders
            (customersToDict customerTab.fetchedCustomers |> Debug.log "kir")
            tableData


tableHeaders : List String
tableHeaders =
    [ "ID", "Name", "View / Add To Receipt" ]


tableData : Customer -> List (Html m)
tableData customer =
    [ td [] [ text <| toString customer.id ]
    , td [] [ text <| customer.firstName ++ " " ++ customer.lastName ]
    ]
