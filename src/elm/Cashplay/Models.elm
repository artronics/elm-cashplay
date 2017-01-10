module Cashplay.Models exposing (..)

import Material
import Customer.Models as Customer exposing (Customer)


type alias Cashplay =
    { currentTab : Int
    , customer : Customer
    , mdl : Material.Model
    }


init : Cashplay
init =
    { currentTab = 0
    , customer = Customer.init
    , mdl = Material.model
    }
