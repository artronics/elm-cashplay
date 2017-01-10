module Cashplay.Models exposing (..)

import Material
import Customer.Models as CustomerTab exposing (CustomerTab)


type alias Cashplay =
    { currentTab : Int
    , customerTab : CustomerTab
    , mdl : Material.Model
    }


init : Cashplay
init =
    { currentTab = 0
    , customerTab = CustomerTab.init
    , mdl = Material.model
    }
