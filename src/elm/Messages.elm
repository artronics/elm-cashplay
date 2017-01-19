module Messages exposing (..)

import Http
import Navigation exposing (Location)
import Cashplay.Messages as Cashplay
import Home.Messages as HomePage
import Api


type Msg
    = OnLocationChange Location
    | HomeMsg HomePage.Msg
    | CashplayMsg Cashplay.Msg
      -- When we start app in dev mode, we send a login req to the server.
      -- Server in dev mode is seeded with given user.
      -- This is required because server will store current user email in server settings
      -- which will be used for subsequents queries
      --TODO delete auto login in production
    | OnDevLogin (Result Http.Error Api.JwtToken)
