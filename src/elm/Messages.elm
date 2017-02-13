module Messages exposing (Msg(..))

import Navigation exposing (Location)
import Shared.Login as Login
import Http
import Api


type Msg
    = OnLocationChange Location
    | LoginMsg Login.Msg
    | OnMe (Result Http.Error Api.Me)
