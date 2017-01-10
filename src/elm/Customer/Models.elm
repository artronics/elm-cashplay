module Customer.Models exposing (CustomerTab, init)

import Html exposing (Html, text, p)
import Material


type alias CustomerTab =
    { mdl : Material.Model
    }


init : CustomerTab
init =
    { mdl = Material.model
    }
