module Customer.Messages exposing (Msg(..))

import Http
import Shared.SearchBar as SearchBar
import Customer.Customer exposing (Customer)


type Msg
    = SearchBarMsg SearchBar.Msg
    | OnSearch (Result Http.Error (List Customer))
