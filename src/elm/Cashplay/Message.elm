module Cashplay.Message exposing (Msg(..))

import Cashplay.Model exposing (Tab)
import Customer.Message as Customer


type Msg
    = ChangeTab Tab
    | CustomerTabMsg Customer.Msg
