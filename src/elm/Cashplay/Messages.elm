module Cashplay.Messages exposing (..)

import Material
import Components.Tab as Tab


type Msg
    = TabMsg Tab.Msg
    | Mdl (Material.Msg Msg)
