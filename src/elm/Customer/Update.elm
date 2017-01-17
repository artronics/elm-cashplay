module Customer.Update exposing (update)

import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab, View(..))
import Customer.SearchBar as SearchBar
import Customer.ResultList as ResultList


update : Msg -> CustomerTab -> ( CustomerTab, Cmd Msg )
update msg customerTab =
    case msg of
        SearchBarMsg msg_ ->
            SearchBar.update msg_ customerTab

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

        SelectCrumb view ->
            ( { customerTab | currentView = view }, Cmd.none )

        OnNewCustomer ->
            ( { customerTab
                | views = [ NewCustomer ]
                , currentView = NewCustomer
              }
            , Cmd.none
            )
