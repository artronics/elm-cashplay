module Models exposing (..)

import Home.Models as HomePage
import Routing exposing (..)
import Cashplay.Models as Cashplay
import Context exposing (..)


type alias Model =
    { login : Bool
    , route : Route
    , context : Context
    , home : HomePage.Home
    , cashplay : Cashplay.Cashplay
    }


model : Route -> Model
model route =
    { login = False
    , route = route
    , context = initContext
    , home = HomePage.init
    , cashplay = Cashplay.init
    }
