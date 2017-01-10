module Cashplay.Update exposing (update)

import Material
import Cashplay.Models exposing (Cashplay)
import Cashplay.Messages exposing (Msg(..))
import Components.Tab as Tab


update : Msg -> Cashplay -> ( Cashplay, Cmd Msg )
update msg cashplay =
    case msg of
        TabMsg msg_ ->
            let
                ( newTab, cmd ) =
                    Tab.update msg_ cashplay.tab
            in
                ( { cashplay | tab = newTab }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ cashplay
