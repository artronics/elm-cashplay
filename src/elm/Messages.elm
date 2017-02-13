module Messages exposing (Msg(..))

import Navigation exposing (Location)
import Shared.Login as Login
import Http
import Api
import Cashplay.Message as Cashplay


type Msg
    = OnLocationChange Location
    | LoginMsg Login.Msg
    | Logout
    | OnMe (Result Http.Error Api.Me)
    | CashplayMsg Cashplay.Msg
