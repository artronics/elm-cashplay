module Customer.ResultList exposing (..)

import Html exposing (..)
import Dict as Dict exposing (Dict)
import Customer.Models exposing (..)
import Customer.Messages exposing (Msg(..))
import Customer.Customer exposing (Customer, customersToDict, new, initCustomerValidation)
import Shared.ViewReceipt as ViewReceipt
import Views.Breadcrumb as Bread
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

        ( views, currentView, customerDetails, breadInfo, customerState, customerValidation ) =
            viewCustomer
                |> Maybe.map
                    (\c ->
                        ( [ SearchResults, CustomerDetails ]
                        , CustomerDetails
                        , c
                        , Bread.None
                        , Presentation
                        , initCustomerValidation
                        )
                    )
                |> Maybe.withDefault
                    ( customerTab.views
                    , customerTab.currentView
                    , customerTab.customerDetails
                    , customerTab.breadInfo
                    , customerTab.customerState
                    , customerTab.customerValidation
                    )
    in
        ( { customerTab
            | viewReceipt = newViewReceipt
            , customerDetails = customerDetails
            , views = views
            , currentView = currentView
            , breadInfo = breadInfo
            , customerState = customerState
            , customerValidation = customerValidation
          }
        , Cmd.none
        )


view : CustomerTab -> Html Msg
view customerTab =
    Html.map ViewReceiptMsg <|
        ViewReceipt.view customerTab.viewReceipt
            tableHeaders
            (customersToDict customerTab.fetchedCustomers)
            tableData


tableHeaders : List String
tableHeaders =
    [ "ID", "Name", "View / Add To Receipt" ]


tableData : Customer -> List (Html m)
tableData customer =
    [ td [] [ text <| toString customer.id ]
    , td [] [ text <| customer.firstName ++ " " ++ customer.lastName ]
    ]
