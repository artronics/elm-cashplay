module Cashplay.Messages exposing (..)

import Material
import Customer.Messages as Customer


type Msg
    = SelectTab Int
    | CustomerMsg Customer.Msg
    | Mdl (Material.Msg Msg)
