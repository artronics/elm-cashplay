module Customer.Update exposing (update)

import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab, View(..), CustomerState(..))
import Customer.SearchBar as SearchBar
import Customer.ResultList as ResultList
import Customer.Customer exposing (..)
import Shared.PicLoader as PicLoader
import Views.Breadcrumb as Bread
import Context exposing (Context)


update : Msg -> CustomerTab -> Context -> ( CustomerTab, Cmd Msg )
update msg customerTab context =
    case msg of
        SearchBarMsg msg_ ->
            SearchBar.update msg_ customerTab context

        ViewReceiptMsg msg_ ->
            ResultList.update msg_ customerTab

        PicLoaderMsg msg_ ->
            let
                ( newPicLoader, cmd ) =
                    PicLoader.update msg_ customerTab.picLoader
            in
                ( { customerTab | picLoader = newPicLoader }, Cmd.map PicLoaderMsg cmd )

        OnSearch (Ok fetchedCustomers) ->
            ( { customerTab
                | views = [ SearchResults ]
                , currentView = SearchResults
                , fetchedCustomers = fetchedCustomers
                , breadInfo = Bread.None
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

        EditCustomerReq (Ok customerResList) ->
            let
                customerRes =
                    customerResList
                        |> List.filter (\{ id } -> id == customerTab.editOrNewCustomer.id)
                        |> List.head
                        |> Maybe.withDefault new
            in
                ( resOk customerTab customerRes "Customer has been updated successfuly.", Cmd.none )

        EditCustomerReq (Err err) ->
            ( { customerTab | breadInfo = Bread.Failure "Network Error. Check Internet Connection." }, Cmd.none )

        NewCustomerReq (Ok customerRes) ->
            ( resOk customerTab customerRes "New Customer has been saved successfuly."
            , Cmd.none
            )

        NewCustomerReq (Err err) ->
            ( { customerTab | breadInfo = Bread.Failure "Network Error. Check Internet Connection." }, Cmd.none )

        SelectCrumb view ->
            ( { customerTab | currentView = view }, Cmd.none )

        EditCustomer ->
            ( changeCustomerState customerTab Edit customerTab.customerDetails
            , Cmd.none
            )

        OnEditCustomerSave ->
            proceedIfValid customerTab context <| updateCustomer context customerTab.editOrNewCustomer EditCustomerReq

        OnEditCustomerCancel ->
            ( customerTab, Cmd.none )

        OnNewCustomer ->
            let
                customerTab_ =
                    changeCustomerState customerTab New new
            in
                ( { customerTab_
                    | views = [ NewCustomer ]
                    , currentView = NewCustomer
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
            proceedIfValid customerTab context <| newCustomer context customerTab.editOrNewCustomer NewCustomerReq

        OnEditOrNewCustomerInput f input ->
            let
                updatedSubject =
                    f customerTab.editOrNewCustomer input
            in
                ( { customerTab | editOrNewCustomer = updatedSubject }, Cmd.none )

        OnCustomerValidation validation ->
            ( { customerTab | customerValidation = validation }, Cmd.none )


changeCustomerState : CustomerTab -> CustomerState -> Customer -> CustomerTab
changeCustomerState customerTab state subject =
    { customerTab
        | breadInfo = Bread.None
        , customerState = state
        , editOrNewCustomer = subject
        , customerValidation = initCustomerValidation
    }


resOk : CustomerTab -> Customer -> String -> CustomerTab
resOk customerTab cusRes sucMsg =
    { customerTab
        | breadInfo = Bread.Success sucMsg
        , customerDetails = cusRes
        , views = [ CustomerDetails ]
        , currentView = CustomerDetails
        , customerState = Presentation
    }


proceedIfValid : CustomerTab -> Context -> Cmd Msg -> ( CustomerTab, Cmd Msg )
proceedIfValid customerTab context cmdOp =
    let
        isValid =
            validate customerTab.editOrNewCustomer |> List.isEmpty

        customerValidation =
            customerTab.customerValidation

        ( customerTab_, cmd ) =
            if isValid then
                ( { customerTab | breadInfo = Bread.Loading }
                , cmdOp
                )
            else
                ( { customerTab | customerValidation = validateCustomer customerTab.editOrNewCustomer }, Cmd.none )
    in
        ( customerTab_, cmd )
