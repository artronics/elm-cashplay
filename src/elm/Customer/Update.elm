module Customer.Update exposing (update, subscriptions)

import Json.Decode as Decode
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab, View(..), CustomerState(..))
import Customer.SearchBar as SearchBar
import Customer.ResultList as ResultList
import Customer.Customer exposing (..)
import Shared.PicLoader as PicLoader
import Shared.PicListLoader as PicListLoader
import Views.Breadcrumb as Bread
import Context exposing (Context)
import Debug


updatePicLoader : PicLoader.Msg -> CustomerTab -> ( CustomerTab, Cmd Msg )
updatePicLoader msg customerTab =
    let
        ( newPicLoader, cmd, pic ) =
            PicLoader.update msg customerTab.picLoader "cus-camera"

        editOrNewCustomer =
            customerTab.editOrNewCustomer

        editOrNewCustomer_ =
            (decodePic pic) |> Maybe.map (\p -> { editOrNewCustomer | pic = p }) |> Maybe.withDefault editOrNewCustomer
    in
        ( { customerTab | picLoader = newPicLoader, editOrNewCustomer = editOrNewCustomer_ }, Cmd.map PicLoaderMsg cmd )


decodePic : Maybe Decode.Value -> Maybe String
decodePic pic =
    pic
        |> Maybe.map (\p -> (Decode.decodeValue Decode.string p) |> Result.toMaybe)
        |> Maybe.andThen (\p -> p |> Maybe.map (\x -> x))


updatePicListLoader : PicListLoader.Msg -> CustomerTab -> ( CustomerTab, Cmd Msg )
updatePicListLoader msg customerTab =
    let
        ( newPicListLoader, cmd, _ ) =
            PicListLoader.update msg customerTab.picListLoader
    in
        ( { customerTab | picListLoader = newPicListLoader }, Cmd.map PicListLoaderMsg cmd )


update : Msg -> CustomerTab -> Context -> ( CustomerTab, Cmd Msg )
update msg customerTab context =
    case msg of
        SearchBarMsg msg_ ->
            SearchBar.update msg_ customerTab context

        ViewReceiptMsg msg_ ->
            ResultList.update msg_ customerTab context

        PicLoaderMsg msg_ ->
            updatePicLoader msg_ customerTab

        PicListLoaderMsg msg_ ->
            updatePicListLoader msg_ customerTab

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

        CustomerPicReq (Ok pic) ->
            let
                customerDetails_ =
                    customerTab.customerDetails

                customerDetails =
                    { customerDetails_ | pic = pic.pic }
            in
                ( { customerTab | customerDetails = customerDetails }, Cmd.none )

        CustomerPicReq (Err err) ->
            ( customerTab, Cmd.none )

        EditCustomerReq (Ok customerRes) ->
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
            ( changeCustomerState customerTab Presentation customerTab.customerDetails
            , Cmd.none
            )

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


subscriptions : CustomerTab -> Sub Msg
subscriptions customerTab =
    Sub.batch
        [ Sub.map PicLoaderMsg <| PicLoader.subscriptions customerTab.picLoader
        , Sub.map PicListLoaderMsg <| PicListLoader.subscriptions customerTab.picListLoader
        ]


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
