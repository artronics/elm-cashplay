module Home.Messages exposing (..)

import Shared.Login as Login
import Shared.Signup as Signup


type Msg
    = LoginMsg Login.Msg
    | SignupMsg Signup.Msg
