module Customer.Models exposing (CustomerTab, init)

import Html exposing (Html, text, p)
import Material
import Shared.SearchBar as SearchBar exposing (SearchBar)


type alias CustomerTab =
    { searchBar : SearchBar
    , mdl : Material.Model
    }


init : CustomerTab
init =
    { searchBar = SearchBar.initSearchBar "Customer's Name"
    , mdl = Material.model
    }
