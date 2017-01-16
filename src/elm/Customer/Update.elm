module Customer.Update exposing (update)

import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab, View(..))
import Customer.SearchBar as SearchBar


update : Msg -> CustomerTab -> ( CustomerTab, Cmd Msg )
update msg customerTab =
    case msg of
        SearchBarMsg msg_ ->
            SearchBar.update msg_ customerTab

        OnSearch (Ok fetchedCustomers) ->
            ( { customerTab
                | views = [ SearchResults ]
                , currentView = SearchResults
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

        SelectCrumb index ->
            let
                currentView =
                    SearchResults
            in
                ( customerTab, Cmd.none )
