module Customer.Model exposing (CustomerTab, init, View(..))


type alias CustomerTab =
    { currentView : View
    }


type View
    = Search
    | New


init : CustomerTab
init =
    { currentView = Search
    }
