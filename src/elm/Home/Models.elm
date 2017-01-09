module Home.Models exposing (Home, init)

import Components.Login exposing (Login, initLogin)
import Components.Signup exposing (Signup, initSignup)


type alias Home =
    { login : Login
    , signup : Signup
    }


init : Home
init =
    { login = initLogin
    , signup = initSignup
    }
