module Cashplay.Models exposing (..)

import Material
import Components.Tab as Tab


type alias Cashplay =
    { tab : Tab.Tab
    , mdl : Material.Model
    }


init : Cashplay
init =
    { tab = Tab.initTab
    , mdl = Material.model
    }
