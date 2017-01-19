module Customer.Update exposing (update)

import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab, View(..))
import Customer.SearchBar as SearchBar
import Customer.ResultList as ResultList
import Customer.Customer exposing (..)
import Views.Breadcrumb as Bread
import Context exposing (Context)


update : Msg -> CustomerTab -> Context -> ( CustomerTab, Cmd Msg )
update msg customerTab context =
    case msg of
        SearchBarMsg msg_ ->
            SearchBar.update msg_ customerTab context

        ViewReceiptMsg msg_ ->
            ResultList.update msg_ customerTab

        OnSearch (Ok fetchedCustomers) ->
            ( { customerTab
                | views = [ SearchResults ]
                , currentView = SearchResults
                , fetchedCustomers = fetchedCustomers
              }
            , Cmd.none
            )

        OnSearch (Err err) ->
            ( { customerTab
                | views = []
                , currentView = NetErr
              }
            , Cmd.none
            )

        NewCustomerReq (Ok customerRes) ->
            ( { customerTab
                | breadInfo = Bread.Success "New Customer has been saved successfuly."
                , customerDetails = Just customerRes
                , views = [ CustomerDetails ]
                , currentView = CustomerDetails
              }
            , Cmd.none
            )

        NewCustomerReq (Err err) ->
            ( { customerTab | breadInfo = Bread.Failure "Network Error. Check Internet Connection." }, Cmd.none )

        SelectCrumb view ->
            ( { customerTab | currentView = view }, Cmd.none )

        OnNewCustomer ->
            ( { customerTab
                | views = [ NewCustomer ]
                , currentView = NewCustomer
                , breadInfo = Bread.None
              }
            , Cmd.none
            )

        OnNewCustomerInput f input ->
            let
                updatedNewCustomer =
                    f customerTab.newCustomer input
            in
                ( { customerTab | newCustomer = updatedNewCustomer }, Cmd.none )

        OnNewCustomerReset ->
            ( { customerTab
                | newCustomer = new
                , customerValidation = initCustomerValidation
                , breadInfo = Bread.None
              }
            , Cmd.none
            )

        OnNewCustomerSave ->
            let
                isValid =
                    validate customerTab.newCustomer |> List.isEmpty

                customerValidation =
                    customerTab.customerValidation

                ( customerTab_, cmd ) =
                    if isValid then
                        ( { customerTab | breadInfo = Bread.Loading }
                        , newCustomer context customerTab.newCustomer NewCustomerReq
                        )
                    else
                        ( { customerTab | customerValidation = validateCustomer customerTab.newCustomer }, Cmd.none )
            in
                ( customerTab_, cmd )

        OnCustomerValidation validation ->
            ( { customerTab | customerValidation = validation }, Cmd.none )
