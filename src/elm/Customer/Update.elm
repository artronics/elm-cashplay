module Customer.Update exposing (update)

import Material
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
                | views = [ SearchResults fetchedCustomers ]
                , currentView = SearchResults fetchedCustomers
              }
            , Cmd.none
            )

        OnSearch (Err err) ->
            ( { customerTab
                | views = [ NetErr "Network Err" ]
                , currentView = NetErr "Network Err"
              }
            , Cmd.none
            )

        Mdl msg_ ->
            Material.update Mdl msg_ customerTab
