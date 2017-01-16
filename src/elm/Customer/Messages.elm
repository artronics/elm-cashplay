module Customer.Messages exposing (Msg(..))

import Http
import Shared.SearchBar as SearchBar
import Customer.Customer exposing (Customer)
import Customer.Models exposing (View)


type Msg
    = SearchBarMsg SearchBar.Msg
    | OnSearch (Result Http.Error (List Customer))
    | SelectCrumb View
    | OnCustomerDetails Customer
