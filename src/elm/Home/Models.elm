module Home.Models exposing (Home)

import Components.Login as Login exposing (Login)


type alias Home =
    { login : Login
    }


init : Home
init =
    { login = Login.init
    }
