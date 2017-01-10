module Customer.Messages exposing (Msg(..))

import Material


type Msg
    = Mdl (Material.Msg Msg)
