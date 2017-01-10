module Customer.Models exposing (Customer, init)

import Html exposing (Html, text, p)
import Material


type alias Customer =
    { mdl : Material.Model
    }


init : Customer
init =
    { mdl = Material.model
    }
