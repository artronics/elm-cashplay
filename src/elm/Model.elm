module Model exposing (Model, init)

import Routing exposing (Route)
import Shared.Login as Login
import Context


type alias Model =
    { route : Route
    , context : Context.Context
    , login : Login.Model
    }


init : Route -> Model
init route =
    { route = route
    , context = Context.init
    , login = Login.init
    }
