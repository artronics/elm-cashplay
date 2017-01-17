module Customer.Messages exposing (Msg(..))

import Http
import Shared.SearchBar as SearchBar
import Customer.Customer exposing (Customer)
import Customer.Models exposing (View)
import Shared.ViewReceipt as ViewReceipt


type Msg
    = SearchBarMsg SearchBar.Msg
    | ViewReceiptMsg ViewReceipt.Msg
    | OnSearch (Result Http.Error (List Customer))
    | SelectCrumb View
    | OnNewCustomer
