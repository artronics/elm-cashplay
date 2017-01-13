module Customer.Models exposing (CustomerTab, View(..), init)

import Material
import Shared.SearchBar as SearchBar exposing (SearchBar)
import Customer.Customer exposing (Customer)


type alias CustomerTab =
    { searchBar : SearchBar
    , currentView : Int
    , views : List View
    , mdl : Material.Model
    }


type View
    = None
    | SearchResults (List Customer)
    | NetErr String


init : CustomerTab
init =
    { searchBar = SearchBar.initSearchBar
    , currentView = 0
    , views = []
    , mdl = Material.model
    }
