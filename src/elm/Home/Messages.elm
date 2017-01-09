module Home.Messages exposing (..)

import Components.Login as Login
import Components.Signup as Signup


type Msg
    = LoginMsg Login.Msg
    | SignupMsg Signup.Msg
