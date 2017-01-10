module Cashplay.Messages exposing (..)

import Material
import Customer.Messages as Customer


type Msg
    = SelectTab Int
    | CustomerTabMsg Customer.Msg
    | Mdl (Material.Msg Msg)
