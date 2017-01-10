module Home.Models exposing (Home, init)

import Shared.Login exposing (Login, initLogin)
import Shared.Signup exposing (Signup, initSignup)


type alias Home =
    { login : Login
    , signup : Signup
    }


init : Home
init =
    { login = initLogin
    , signup = initSignup
    }
