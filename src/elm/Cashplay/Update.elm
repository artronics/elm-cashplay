module Cashplay.Update exposing (update)

import Cashplay.Models exposing (Cashplay)
import Cashplay.Messages exposing (Msg(..))


update : Msg -> Cashplay -> ( Cashplay, Cmd Msg )
update msg cashplay =
    case msg of
        NoOp ->
            ( cashplay, Cmd.none )
