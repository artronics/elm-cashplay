module Customer.Model exposing (CustomerTab, init, View(..))

import Customer.NewCustomer as NewCustomer


type alias CustomerTab =
    { currentView : View
    , newCustomer : NewCustomer.Model
    }


type View
    = Search
    | New


init : CustomerTab
init =
    { currentView = Search
    , newCustomer = NewCustomer.init
    }
