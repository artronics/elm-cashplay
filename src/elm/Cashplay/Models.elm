module Cashplay.Models exposing (..)

import Customer.Models as CustomerTab exposing (CustomerTab)


type alias Cashplay =
    { currentTab : Tab
    , customerTab : CustomerTab
    }


type Tab
    = CustomerTab
    | ItemTab


init : Cashplay
init =
    { currentTab = CustomerTab
    , customerTab = CustomerTab.init
    }
