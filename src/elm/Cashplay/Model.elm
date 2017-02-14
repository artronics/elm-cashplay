module Cashplay.Model exposing (Cashplay, init, Tab(..))

import Customer.Model as Customer


type alias Cashplay =
    { currentTab : Tab
    , customerTab : Customer.CustomerTab
    }


type Tab
    = CustomerTab
    | ItemTab


init : Cashplay
init =
    { currentTab = CustomerTab
    , customerTab = Customer.init
    }
