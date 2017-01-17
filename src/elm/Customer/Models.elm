module Customer.Models exposing (CustomerTab, View(..), init)

import Shared.SearchBar as SearchBar exposing (SearchBar)
import Shared.ViewReceipt as ViewReceipt
import Customer.Customer exposing (Customer)


type alias CustomerTab =
    { searchBar : SearchBar
    , viewReceipt : ViewReceipt.Model
    , fetchedCustomers : List Customer
    , customerDetails : Maybe Customer
    , currentView : View
    , views : List View
    }


type View
    = None
    | SearchResults
    | CustomerDetails
    | NewCustomer
    | NetErr


init : CustomerTab
init =
    { searchBar = SearchBar.initSearchBar
    , viewReceipt = ViewReceipt.init
    , fetchedCustomers = []
    , customerDetails = Nothing
    , currentView = None
    , views = []
    }
