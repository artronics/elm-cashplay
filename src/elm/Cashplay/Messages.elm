module Cashplay.Messages exposing (..)

import Customer.Messages as Customer
import Cashplay.Models exposing (Tab)


type Msg
    = SelectTab Tab
    | CustomerTabMsg Customer.Msg
