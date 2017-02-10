module Customer.Models exposing (CustomerTab, View(..), init, CustomerState(..))

import Shared.SearchBar as SearchBar exposing (SearchBar)
import Shared.ViewReceipt as ViewReceipt
import Customer.Customer as Cus exposing (Customer, CustomerValidation, initCustomerValidation)
import Views.Breadcrumb as Bread
import Shared.PicLoader as PicLoader
import Shared.PicListLoader as PicListLoader
import Shared.ImgInput as ImgInput


type alias CustomerTab =
    { searchBar : SearchBar
    , viewReceipt : ViewReceipt.Model
    , picLoader : PicLoader.Model
    , picListLoader : PicListLoader.Model
    , imgInput : ImgInput.Model
    , fetchedCustomers : List Customer
    , customerDetails : Customer
    , customerState : CustomerState
    , editOrNewCustomer : Customer
    , customerValidation : CustomerValidation
    , currentView : View
    , views : List View
    , breadInfo : Bread.Info
    }


type CustomerState
    = Presentation
    | Edit
    | New


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
    , picLoader = PicLoader.init
    , picListLoader = PicListLoader.init
    , imgInput = ImgInput.init
    , fetchedCustomers = []
    , customerDetails = Cus.new
    , customerState = Presentation
    , editOrNewCustomer = Cus.new
    , customerValidation = initCustomerValidation
    , currentView = None
    , views = []
    , breadInfo = Bread.None
    }
