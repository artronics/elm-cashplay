module Context exposing (..)

import Api


type alias Context =
    { jwt : Api.JwtToken
    }


initContext : Context
initContext =
    { jwt = { token = "" } }
