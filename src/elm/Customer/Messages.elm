module Customer.Messages exposing (Msg(..))

import Http
import Shared.SearchBar as SearchBar
import Customer.Customer exposing (Customer, CustomerValidation)
import Customer.Models exposing (CustomerTab, View)
import Shared.ViewReceipt as ViewReceipt
import Shared.PicLoader as PicLoader


type Msg
    = SearchBarMsg SearchBar.Msg
    | ViewReceiptMsg ViewReceipt.Msg
    | PicLoaderMsg PicLoader.Msg
    | OnSearch (Result Http.Error (List Customer))
    | SelectCrumb View
    | OnNewCustomer
    | OnNewCustomerReset
    | OnNewCustomerSave
    | NewCustomerReq (Result Http.Error Customer)
    | EditCustomer
    | OnEditCustomerSave
    | OnEditCustomerCancel
    | EditCustomerReq (Result Http.Error (List Customer))
    | OnEditOrNewCustomerInput (Customer -> String -> Customer) String
    | OnCustomerValidation CustomerValidation



--    | OnNewCustomerSave
