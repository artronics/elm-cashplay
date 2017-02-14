module Cashplay.Model exposing (Cashplay, init, Tab(..))


type alias Cashplay =
    { currentTab : Tab
    }


type Tab
    = CustomerTab
    | ItemTab


init : Cashplay
init =
    { currentTab = CustomerTab
    }
