module Customer.Messages exposing (Msg(..))

import Material
import Shared.SearchBar as SearchBar


type Msg
    = SearchBarMsg SearchBar.Msg
    | Mdl (Material.Msg Msg)
