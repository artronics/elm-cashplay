module Customer.Models exposing (CustomerTab, View(..), init)

import Shared.SearchBar as SearchBar exposing (SearchBar)
import Customer.Customer exposing (Customer)


type alias CustomerTab =
    { searchBar : SearchBar
    , fetchedCustomers : List Customer
    , currentView : View
    , views : List View
    }


type View
    = None
    | SearchResults
    | NetErr


init : CustomerTab
init =
    { searchBar = SearchBar.initSearchBar
    , fetchedCustomers = []
    , currentView = None
    , views = []
    }
