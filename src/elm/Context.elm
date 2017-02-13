module Context exposing (Context, init)


type alias Context =
    { jwt : Maybe String
    }


init : Context
init =
    { jwt = Nothing
    }
