module Customer.Models exposing (CustomerTab, View(..), init)

import Shared.SearchBar as SearchBar exposing (SearchBar)
import Customer.Customer exposing (Customer)


type alias CustomerTab =
    { searchBar : SearchBar
    , currentView : View
    , views : List View
    }


type View
    = None
    | SearchResults (List Customer)
    | NetErr String


init : CustomerTab
init =
    { searchBar = SearchBar.initSearchBar
    , currentView = None
    , views = []
    }
