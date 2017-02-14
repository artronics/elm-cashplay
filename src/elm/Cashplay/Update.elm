module Cashplay.Update exposing (update)

import Cashplay.Model exposing (Cashplay)
import Cashplay.Message exposing (Msg(..))
import Context exposing (Context)


update : Msg -> Cashplay -> Context -> ( Cashplay, Cmd Msg )
update msg model context =
    case msg of
        ChangeTab tab ->
            ( { model | currentTab = tab }, Cmd.none )
