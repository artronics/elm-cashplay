module Customer.Models exposing (CustomerTab, View(..), init, CustomerValidation)

import Shared.SearchBar as SearchBar exposing (SearchBar)
import Shared.ViewReceipt as ViewReceipt
import Customer.Customer as Cus exposing (Customer)


type alias CustomerTab =
    { searchBar : SearchBar
    , viewReceipt : ViewReceipt.Model
    , fetchedCustomers : List Customer
    , customerDetails : Maybe Customer
    , editCustomer : Bool
    , newCustomer : Customer
    , customerValidation : CustomerValidation
    , currentView : View
    , views : List View
    }


type alias CustomerValidation =
    { firstName : Maybe String
    }


initCustomerValidation =
    { firstName = Nothing
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
    , editCustomer = False
    , newCustomer = Cus.new
    , customerValidation = initCustomerValidation
    , currentView = None
    , views = []
    }
