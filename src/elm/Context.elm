module Context exposing (Context, init)

import Api


type alias Context =
    { jwt : Maybe String
    , me : Api.Me
    }


init : Context
init =
    { jwt = Nothing
    , me = Api.newMe
    }
