module Customer.Models exposing (CustomerTab, View(..), init)

import Shared.SearchBar as SearchBar exposing (SearchBar)
import Customer.Customer exposing (Customer)


type alias CustomerTab =
    { searchBar : SearchBar
    , fetchedCustomers : List Customer
    , customerDetails : Maybe Customer
    , currentView : View
    , views : List View
    }


type View
    = None
    | SearchResults
    | CustomerDetails
    | NetErr


init : CustomerTab
init =
    { searchBar = SearchBar.initSearchBar
    , fetchedCustomers = []
    , customerDetails = Nothing
    , currentView = None
    , views = []
    }
