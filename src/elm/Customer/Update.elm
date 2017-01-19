module Customer.Update exposing (update)

import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab, View(..), CustomerState(..))
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
                , customerDetails = customerRes
                , views = [ CustomerDetails ]
                , currentView = CustomerDetails
              }
            , Cmd.none
            )

        NewCustomerReq (Err err) ->
            ( { customerTab | breadInfo = Bread.Failure "Network Error. Check Internet Connection." }, Cmd.none )

        SelectCrumb view ->
            ( { customerTab | currentView = view }, Cmd.none )

        EditCustomer ->
            ( { customerTab
                | customerState = Edit
                , editOrNewCustomer = customerTab.customerDetails
              }
            , Cmd.none
            )

        OnNewCustomer ->
            ( { customerTab
                | views = [ NewCustomer ]
                , currentView = NewCustomer
                , breadInfo = Bread.None
                , customerState = New
                , editOrNewCustomer = new
                , customerValidation = initCustomerValidation
              }
            , Cmd.none
            )

        OnNewCustomerReset ->
            ( { customerTab
                | editOrNewCustomer = new
                , customerValidation = initCustomerValidation
                , breadInfo = Bread.None
              }
            , Cmd.none
            )

        OnNewCustomerSave ->
            let
                isValid =
                    validate customerTab.editOrNewCustomer |> List.isEmpty

                customerValidation =
                    customerTab.customerValidation

                ( customerTab_, cmd ) =
                    if isValid then
                        ( { customerTab | breadInfo = Bread.Loading }
                        , newCustomer context customerTab.editOrNewCustomer NewCustomerReq
                        )
                    else
                        ( { customerTab | customerValidation = validateCustomer customerTab.editOrNewCustomer }, Cmd.none )
            in
                ( customerTab_, cmd )

        OnEditOrNewCustomerInput f input ->
            let
                updatedSubject =
                    f customerTab.editOrNewCustomer input
            in
                ( { customerTab | editOrNewCustomer = updatedSubject }, Cmd.none )

        OnCustomerValidation validation ->
            ( { customerTab | customerValidation = validation }, Cmd.none )
