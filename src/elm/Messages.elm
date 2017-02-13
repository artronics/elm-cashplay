module Messages exposing (Msg(..))

import Navigation exposing (Location)
import Shared.Login as Login


type Msg
    = OnLocationChange Location
    | LoginMsg Login.Msg
