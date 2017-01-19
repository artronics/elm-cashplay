module Models exposing (..)

import Messages exposing (..)
import Home.Models as HomePage
import Routing exposing (..)
import Cashplay.Models as Cashplay
import Navigation exposing (Location)
import Api


type alias Model =
    { login : Bool
    , route : Route
    , jwt : String
    , home : HomePage.Home
    , cashplay : Cashplay.Cashplay
    }


model : Route -> Model
model route =
    { login = False
    , route = route
    , jwt = ""
    , home = HomePage.init
    , cashplay = Cashplay.init
    }
