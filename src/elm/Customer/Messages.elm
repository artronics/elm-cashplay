module Customer.Messages exposing (Msg(..))

import Http
import Shared.SearchBar as SearchBar
import Customer.Customer exposing (Customer, CustomerValidation)
import Customer.Models exposing (CustomerTab, View)
import Shared.ViewReceipt as ViewReceipt


type Msg
    = SearchBarMsg SearchBar.Msg
    | ViewReceiptMsg ViewReceipt.Msg
    | OnSearch (Result Http.Error (List Customer))
    | SelectCrumb View
    | OnNewCustomer
    | OnNewCustomerInput (Customer -> String -> Customer) String
    | OnNewCustomerReset
    | OnNewCustomerSave
    | NewCustomerReq (Result Http.Error Customer)
    | OnCustomerValidation CustomerValidation



--    | OnNewCustomerSave
