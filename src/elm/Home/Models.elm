module Home.Models exposing (Home, init)

import Components.Login exposing (Login, loginInit)


type alias Home =
    { login : Components.Login.Login
    }


init : Home
init =
    { login = loginInit
    }
