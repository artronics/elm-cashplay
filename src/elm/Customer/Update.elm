module Customer.Update exposing (update)

import Material
import Customer.Messages exposing (Msg(..))
import Customer.Models exposing (CustomerTab)
import Customer.SearchBar as SearchBar


update : Msg -> CustomerTab -> ( CustomerTab, Cmd Msg )
update msg customerTab =
    case msg of
        SearchBarMsg msg_ ->
            let
                ( newSearchBar, cmd ) =
                    SearchBar.update msg_ customerTab.searchBar
            in
                ( { customerTab | searchBar = newSearchBar }, Cmd.map SearchBarMsg cmd )

        Mdl msg_ ->
            Material.update Mdl msg_ customerTab
