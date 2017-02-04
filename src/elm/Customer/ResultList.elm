module Customer.ResultList exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Dict as Dict exposing (Dict)
import Customer.Models exposing (..)
import Customer.Messages exposing (Msg(..))
import Customer.Customer exposing (Customer, customersToDict, new, initCustomerValidation, getCustomerPic)
import Shared.ViewReceipt as ViewReceipt
import Views.Breadcrumb as Bread
import Context exposing (Context)
import Debug


update : ViewReceipt.Msg -> CustomerTab -> Context -> ( CustomerTab, Cmd Msg )
update msg customerTab context =
    let
        getRes =
            \key ->
                customersToDict customerTab.fetchedCustomers
                    |> Dict.get key

        ( newViewReceipt, ( viewCustomer, _ ) ) =
            ViewReceipt.update msg customerTab.viewReceipt getRes

        ( views, currentView, customerDetails, breadInfo, customerState, customerValidation, cmd ) =
            viewCustomer
                |> Maybe.map
                    (\c ->
                        ( [ SearchResults, CustomerDetails ]
                        , CustomerDetails
                        , c
                        , Bread.None
                        , Presentation
                        , initCustomerValidation
                        , getCustomerPic context (toString c.id) CustomerPicReq
                        )
                    )
                |> Maybe.withDefault
                    ( customerTab.views
                    , customerTab.currentView
                    , customerTab.customerDetails
                    , customerTab.breadInfo
                    , customerTab.customerState
                    , customerTab.customerValidation
                    , Cmd.none
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
        , cmd
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
    , td [ class "text-capitalize" ] [ text <| customer.firstName ++ " " ++ customer.lastName ]
    ]
