module Model exposing (Model, init)

import Routing exposing (Route)
import Shared.Login as Login
import Context
import Cashplay.Model as Cashplay


type alias Model =
    { route : Route
    , loggedIn : Bool
    , context : Context.Context
    , login : Login.Model
    , cashplay : Cashplay.Model
    }


init : Route -> Model
init route =
    { route = route
    , loggedIn = False
    , context = Context.init
    , login = Login.init
    , cashplay = Cashplay.init
    }
