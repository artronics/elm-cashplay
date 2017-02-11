module Customer.Models exposing (CustomerTab, View(..), init, CustomerState(..))

import Shared.SearchBar as SearchBar exposing (SearchBar)
import Shared.ViewReceipt as ViewReceipt
import Customer.Customer as Cus exposing (Customer, CustomerValidation, initCustomerValidation)
import Views.Breadcrumb as Bread
import Shared.PicListLoader as PicListLoader
import Shared.ImgInput as ImgInput
import Shared.ImgListInput as ImgListInput


type alias CustomerTab =
    { searchBar : SearchBar
    , viewReceipt : ViewReceipt.Model
    , picListLoader : PicListLoader.Model
    , imgInput : ImgInput.Model
    , imgListInput : ImgListInput.Model
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
    , picListLoader = PicListLoader.init
    , imgInput = ImgInput.init
    , imgListInput = ImgListInput.init
    , fetchedCustomers = []
    , customerDetails = Cus.new
    , customerState = Presentation
    , editOrNewCustomer = Cus.new
    , customerValidation = initCustomerValidation
    , currentView = None
    , views = []
    , breadInfo = Bread.None
    }
